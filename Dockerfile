FROM python:3.8.3-slim-buster

WORKDIR /root
COPY boblight/ /root/boblight/
COPY boblight.conf /etc/boblight.conf
COPY entrypoint.sh /root/entrypoint.sh
COPY etc.boblight /etc/init.d/boblight 

RUN apt-get update
RUN apt-get install -y build-essential autoconf libtool libusb-1.0-0-dev portaudio19-dev 
#RUN git clone http://github.com/arvydas/boblight

RUN cd /root/boblight && /root/boblight/autogen.sh 
RUN cd /root/boblight && /root/boblight/configure --without-x11 --prefix=/usr --without-portaudio
RUN cd /root/boblight && make
RUN cd /root/boblight && make install

RUN useradd -r -s /bin/false boblightd
RUN chmod 755 /etc/init.d/boblight
RUN update-rc.d boblight defaults

ENTRYPOINT /root/entrypoint.sh
#EXPOSE 19333
