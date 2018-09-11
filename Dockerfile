FROM ubuntu:xenial

ENV MEDIADIR=/avreg_media
ENV DBDIR=/avreg_db

RUN mkdir $MEDIADIR && ln -s $MEDIADIR /var/spool/avreg

VOLUME /avreg_db /avreg_media

# add avreg repository to application sources
RUN echo "deb http://avreg.net/repos/6.3-html5/ubuntu/ xenial main contrib non-free" >> /etc/apt/sources.list
# remove policy file to allow start services while apt-get install
RUN rm -rf /usr/sbin/policy-rc.d

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --allow-unauthenticated avreg-server-mysql 
RUN service avreg stop

# entry point will start mysql, apache2, and avreg services and stop them as well on demand
ADD entry_point.sh /
CMD ["/entry_point.sh"]

EXPOSE 80

