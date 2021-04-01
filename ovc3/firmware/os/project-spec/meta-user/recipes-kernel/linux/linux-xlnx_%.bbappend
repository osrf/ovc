SRC_URI += "file://user_2019-01-11-16-52-00.cfg \
            file://user_2019-02-20-18-00-00.cfg \
            file://user_2019-02-21-10-02-00.cfg \
            file://user_2019-02-21-13-39-00.cfg \
            file://user_2019-02-22-15-44-00.cfg \
            file://user_2019-05-15-09-56-00.cfg \
            file://user_2019-06-13-17-11-00.cfg \
            file://user_2019-06-19-14-50-00.cfg \
            file://user_2019-06-24-16-07-00.cfg \
            file://user_2019-06-24-16-36-00.cfg \
            "

SRC_URI_append += "file://0001-Change-bMaxBurst-and-qlen-to-the-highest-number.patch"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

