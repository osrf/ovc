#!/usr/bin/env python
import numpy as np
import ctypes
#from ctypes import cdll
#from ctypes import pythonapi
ovc_lib = ctypes.cdll.LoadLibrary('./libovc_c.so')
import rospy
from sensor_msgs.msg import Image
import cv2
from cv_bridge import CvBridge

class CameraNode:
    def __init__(self):
        self.image_pub = rospy.Publisher('image', Image, queue_size=2)
        self.bridge = CvBridge()

    def spin(self):
        rc = ovc_lib.ovc_init()
        print("ovc init rc = %d" % rc)
        while not rospy.is_shutdown():
            image_data = ovc_lib.ovc_wait_for_image()
            if image_data:
                ovc_lib.ovc_autoexposure()
                buffer_from_memory = ctypes.pythonapi.PyBuffer_FromMemory
                buffer_from_memory.restype = ctypes.py_object
                raw_buffer = buffer_from_memory(image_data, 1280*1024)
                raw_image = np.frombuffer(raw_buffer, dtype=np.uint8)
                raw_image.shape = (1024, 1280)
                small_image = cv2.resize(raw_image, (640, 512))
                #small_image = cv2.resize(raw_image, (256, 256))
                self.image_pub.publish(self.bridge.cv2_to_imgmsg(small_image, 'mono8'))

            else:
                print("oh no, got NULL pointer from ovc lib :(")
                break
        rc = ovc_lib.ovc_fini()
        print("ovc fini rc = %d" % rc)

##############################################
rospy.init_node('ovc_single_cam')
cn = CameraNode()
cn.spin()
