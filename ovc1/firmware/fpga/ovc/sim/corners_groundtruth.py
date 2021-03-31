#!/usr/bin/env python
import numpy as np
import cv2
from matplotlib import pyplot as pl

img = cv2.imread('image0006_middle.png', cv2.IMREAD_COLOR)
fast = cv2.FastFeatureDetector()
fast.setInt('threshold', 29)  #79)
#print("type: %d" % fast.getInt('Type'))
#fast.setBool('nonmaxSuppression', False)
kp = fast.detect(img, None)
for p in kp:
    x = p.pt[0]
    y = p.pt[1]
    score = p.response
    print("%5d %5d %5d" % (x, y, score))
    cv2.circle(img, (int(x), int(y)), 3, (0, 0, 255))
#img2 = cv2.drawKeypoints(img, kp, color=(0, 0, 255))

with open('corners.txt') as f:
    for line in f:
        tokens = line.split()
        x = int(tokens[0])
        y = int(tokens[1])
        cv2.circle(img, (x, y), 5, (0, 255, 0))

#cv2.imwrite('keypoints.png', img)
cv2.imshow('keypoints', img)
cv2.waitKey(0)
