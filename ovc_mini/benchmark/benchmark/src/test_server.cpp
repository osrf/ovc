#include <netinet/in.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/socket.h>
#include <unistd.h>

#include <algorithm>
#include <iostream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

const static int BUFFER_SIZE = 256;
// Number of bytes to send at a time.
const static int BATCH_SIZE = 1024;

class ServerSocket
{
private:
  int opt = 1;
  int server_fd = 0;
  int client_sock;
  sockaddr_in address;
  int addrlen;
  char buffer[BUFFER_SIZE] = {0};
  char msg_buf[BATCH_SIZE] = {0};

public:
  ServerSocket(int port)
  {
    addrlen = sizeof(address);
    // Set the msg buf contents to be all 'A'.
    for (size_t i = 0; i < BATCH_SIZE; i++)
    {
      msg_buf[i] = 'A';
    }

    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
      std::runtime_error("socket failed");
    }

    if (setsockopt(server_fd,
                   SOL_SOCKET,
                   SO_REUSEADDR | SO_REUSEPORT,
                   &opt,
                   sizeof(opt)))
    {
      std::runtime_error("setsockopt");
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);

    // Forcefully attaching socket to the port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0)
    {
      std::runtime_error("bind failed");
    }
    if (listen(server_fd, 3) < 0)
    {
      std::runtime_error("listen");
    }
    if ((client_sock = accept(
             server_fd, (struct sockaddr *)&address, (socklen_t *)&addrlen)) <
        0)
    {
      std::runtime_error("accept");
    }
  }

  ~ServerSocket() { shutdown(server_fd, SHUT_WR); }

  // Send bytes for the given message size.
  void send_msg(long long int msg_size)
  {
    while (msg_size > 0)
    {
      size_t send_size = BATCH_SIZE;
      if (msg_size < BATCH_SIZE)
      {
        send_size = msg_size;
      }

      send(client_sock, msg_buf, send_size, 0);
      msg_size -= send_size;
    }
  }
};

typedef struct
{
  ServerSocket *server;
  sem_t available_packets;
  float packet_size = 5.0;  // Megabytes
  bool test_finished = false;
  int port = 8090;
} config_t;

void *sendThread(void *vargp)
{
  config_t *config = (config_t *)vargp;

  //
  long long int msg_size = (long long int)(config->packet_size * 1000000);
  while (!config->test_finished)
  {
    sem_wait(&config->available_packets);
    config->server->send_msg(msg_size);
    std::cout << "Send" << std::endl;
  }
  return 0;
}

// Wonderful copy pasta: https://stackoverflow.com/a/868894
class InputParser
{
public:
  InputParser(int &argc, char **argv)
  {
    for (int i = 1; i < argc; ++i) this->tokens.push_back(std::string(argv[i]));
  }
  /// @author iain
  const std::string &getCmdOption(const std::string &option) const
  {
    std::vector<std::string>::const_iterator itr;
    itr = std::find(this->tokens.begin(), this->tokens.end(), option);
    if (itr != this->tokens.end() && ++itr != this->tokens.end())
    {
      return *itr;
    }
    static const std::string empty_string("");
    return empty_string;
  }
  /// @author iain
  bool cmdOptionExists(const std::string &option) const
  {
    return std::find(this->tokens.begin(), this->tokens.end(), option) !=
           this->tokens.end();
  }

private:
  std::vector<std::string> tokens;
};

int main(int argc, char **argv)
{
  pthread_t send_thread;
  config_t config;
  float interval = 0.1f;
  long execution_time = 60;

  InputParser input(argc, argv);

  // Duration time collection.
  const std::string s_str = input.getCmdOption("-s");
  if (!s_str.empty())
  {
    config.packet_size = std::stof(s_str);
  }
  std::cout << "Packet size set to " << config.packet_size << std::endl;

  const std::string p_str = input.getCmdOption("-p");
  if (!p_str.empty())
  {
    config.port = std::stoi(p_str);
  }
  std::cout << "Port set to " << config.port << std::endl;

  // Interval time collection.
  const std::string i_str = input.getCmdOption("-i");
  if (!i_str.empty())
  {
    interval = std::stof(i_str);
  }
  std::cout << "Interval set to " << interval << std::endl;

  // Duration time collection.
  const std::string d_str = input.getCmdOption("-d");
  if (!d_str.empty())
  {
    execution_time = std::stol(d_str);
  }
  std::cout << "Duration set to " << execution_time << std::endl;

  ServerSocket sock(config.port);
  config.server = &sock;

  // Wait for the client to connect before spinning up threads.
  sem_init(&config.available_packets, 0, 1);

  pthread_create(&send_thread, NULL, sendThread, (void *)&config);

  int backup = 0;
  long int interval_int = (long int)(interval * 1000000);
  std::chrono::microseconds chrono_interval(interval_int);
  // Make the first post and immediately record the start time.
  sem_post(&config.available_packets);
  std::chrono::steady_clock::time_point start =
      std::chrono::steady_clock::now();
  std::chrono::steady_clock::time_point wake = start + chrono_interval;

  // Only continue looping if the wake time is within the execution time.
  while (wake - start < std::chrono::seconds(execution_time))
  {
    // Sleep for the remaining of the time.
    std::cout << "Wait" << std::endl;
    std::this_thread::sleep_until(wake);
    // Increment the semaphore's value as soon as we wake.
    sem_post(&config.available_packets);
    std::cout << "Post" << std::endl;
    // Increment the wake time by the fixed interval.
    wake += chrono_interval;

    // By now, the semaphore should be back at one. If not, we want to know.
    // This should be greater than one. If negative one, the scheduler halted
    // this process in between the sem_post and sem_getvalue and scheduled the
    // entire send before returning to this thread. Highly unlikely.
    int ret_val = sem_getvalue(&config.available_packets, &backup);
    if (0 != ret_val)
    {
      std::runtime_error("Could not get semaphore's value");
    }
    if (backup != 1)
    {
      std::cout << "Backup " << backup - 1 << std::endl;
    }
  }

  std::cout << "Finished" << std::endl;
  config.test_finished = true;
  pthread_join(send_thread, NULL);
  sem_destroy(&config.available_packets);
  return 0;
}
