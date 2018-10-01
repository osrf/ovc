---
layout: default
---

## Software

We have a collection of repositories to support the OVC for various computer
vision and robotics related tasks,

### Real-time Semantic Segmentation
<ul>
<li><a href="https://github.com/ShreyasSkandanS/ss_segmentation.git">GitHub</a></li>
<li>Type: ROS | Python | PyTorch</li>
<li>Details: This package is based on ERFNet, a semantic segmentation deep learning
network architecture. We have packaged together a quick and simple way to train
this model on two classes for fast and accurate object segmentation. This
package is designed to work on the OVC platform and we have achieved accurate
object detection results at 10Hz at half the original camera resolution.</li>
</ul>

### Stereo Image Splitter
<ul>
<li><a
href="https://github.com/ShreyasSkandan/splitter.git">GitHub</a></li>
<li>Type: ROS | C++ | OpenCV</li>
<li>Details: This is a simple but useful ROS node to de-couple the single
stacked, synchronized images into two individual synchronized image streams for
both individual imagers.</li>
</ul>

### Stereo Image Rectifier
<ul>
<li><a href="https://github.com/ShreyasSkandanS/stereo_fisheye_rectify.git">GitHub</a></li>
<li>Type: ROS | C++ | OpenCV</li>
<li>Details: For our robotics related applications, we use a pair of wide-angle
lenses for our cameras. This package performs a fisheye rectification of input
images, either in the vertically concatenated stacked format or as synchronized
separate image streams.</li>
</ul>

### GPU Accelerated Dense Stereo Disparity Estimation
<ul>
<li><a
href="https://github.com/ShreyasSkandanS/cuda_sgm_ros.git">GitHub</a></li>
<li>Type: ROS | C++ | OpenCV</li>
<li>Details: A ROS node of the Semi-Global Matching algorithm implemented originally by
Hernandez et. al with a few modifications and a ROS front-end. Performs dense
stereo depth estimation, with point cloud, disparity image and regular 8bit
disparity image topics.</li>
</ul>

### Stereo Visual Inertial Odometry

<ul>
<li>Coming soon..</li>
</ul>

### Multicamera Calibration
<ul>
<li>Coming soon..</li>
</ul>

[back](./)
