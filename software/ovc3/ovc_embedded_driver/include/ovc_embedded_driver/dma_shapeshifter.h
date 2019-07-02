/*********************************************************************
* Software License Agreement (BSD License)
*
*  Copyright (c) 2009, Willow Garage, Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*   * Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*   * Redistributions in binary form must reproduce the above
*     copyright notice, this list of conditions and the following
*     disclaimer in the documentation and/or other materials provided
*     with the distribution.
*   * Neither the name of Willow Garage, Inc. nor the names of its
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
*  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
*  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
*  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
*  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
*  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
*  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
*  POSSIBILITY OF SUCH DAMAGE.
********************************************************************/

#ifndef DMA_SHAPESHIFTER_H
#define DMA_SHAPESHIFTER_H

#include "ros/ros.h"
#include "ros/console.h"
#include "ros/assert.h"
#include <vector>
#include <string>
#include <string.h>

#include <ros/message_traits.h>
#include "topic_tools/macros.h"

class DMAShapeShifterException : public ros::Exception
{
public:
  DMAShapeShifterException(const std::string& msg)
    : ros::Exception(msg)  {}
};


class TOPIC_TOOLS_DECL DMAShapeShifter
{
public:
  typedef boost::shared_ptr<DMAShapeShifter> Ptr;
  typedef boost::shared_ptr<DMAShapeShifter const> ConstPtr;

  static bool uses_old_API_;

  // Constructor and destructor
  DMAShapeShifter();
  virtual ~DMAShapeShifter();

  // Helpers for inspecting shapeshifter
  std::string const& getDataType()          const;
  std::string const& getMD5Sum()            const;
  std::string const& getMessageDefinition() const;

  void morph(const std::string& md5sum, const std::string& datatype, const std::string& msg_def,
             const std::string& latching);

  // Helper for advertising
  ros::Publisher advertise(ros::NodeHandle& nh, const std::string& topic, uint32_t queue_size_, bool latch=false, 
                           const ros::SubscriberStatusCallback &connect_cb=ros::SubscriberStatusCallback()) const;

  //! Call to try instantiating as a particular type
  template<class M> 
  boost::shared_ptr<M> instantiate() const;

  //! Write serialized message contents out to a stream
  template<typename Stream>
  void write(Stream& stream) const;

  template<typename Stream>
  void read(Stream& stream);

  // Assign pre-serialized data from existing pointer
  void assign_data(uint8_t *data_ptr, size_t len);
  //! Return the size of the serialized message
  uint32_t size() const;

private:

  std::string md5, datatype, msg_def, latching;
  bool typed;
  bool use_dma;

  uint8_t *msgBuf;
  uint32_t msgBufUsed;
  uint32_t msgBufAlloc;
  
};

// Message traits allow shape shifter to work with the new serialization API
namespace ros {
namespace message_traits {

template <> struct IsMessage<DMAShapeShifter> : TrueType { };
template <> struct IsMessage<const DMAShapeShifter> : TrueType { };

template<>
struct MD5Sum<DMAShapeShifter>
{
  static const char* value(const DMAShapeShifter& m) { return m.getMD5Sum().c_str(); }

  // Used statically, a shapeshifter appears to be of any type
  static const char* value() { return "*"; }
};

template<>
struct DataType<DMAShapeShifter>
{
  static const char* value(const DMAShapeShifter& m) { return m.getDataType().c_str(); }

  // Used statically, a shapeshifter appears to be of any type
  static const char* value() { return "*"; }
};

template<>
struct Definition<DMAShapeShifter>
{
  static const char* value(const DMAShapeShifter& m) { return m.getMessageDefinition().c_str(); }
};

} // namespace message_traits


namespace serialization
{

template<>
struct Serializer<DMAShapeShifter>
{
  template<typename Stream>
  inline static void write(Stream& stream, const DMAShapeShifter& m) {
    m.write(stream);
  }

  template<typename Stream>
  inline static void read(Stream& stream, DMAShapeShifter& m)
  {
    m.read(stream);
  }

  inline static uint32_t serializedLength(const DMAShapeShifter& m) {
    return m.size();
  }
};


template<>
struct PreDeserialize<DMAShapeShifter>
{
  static void notify(const PreDeserializeParams<DMAShapeShifter>& params)
  {
    std::string md5      = (*params.connection_header)["md5sum"];
    std::string datatype = (*params.connection_header)["type"];
    std::string msg_def  = (*params.connection_header)["message_definition"];
    std::string latching  = (*params.connection_header)["latching"];

    params.message->morph(md5, datatype, msg_def, latching);
  }
};

} // namespace serialization

} //namespace ros



// Template implementations:

template<typename Stream>
void DMAShapeShifter::write(Stream& stream) const {
  if (msgBufUsed > 0)
    memcpy(stream.advance(msgBufUsed), msgBuf, msgBufUsed);
}

template<typename Stream>
void DMAShapeShifter::read(Stream& stream)
{
  stream.getLength();
  stream.getData();
    
  // stash this message in our buffer
  if (stream.getLength() > msgBufAlloc)
  {
    if (use_dma == false)
      delete[] msgBuf;
    msgBuf = new uint8_t[stream.getLength()];
    msgBufAlloc = stream.getLength();
  }
  msgBufUsed = stream.getLength();
  memcpy(msgBuf, stream.getData(), stream.getLength());
  use_dma = false;
}


#endif

