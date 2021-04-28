# Use an official node image
FROM node:14.16-buster

ARG DEBIAN_FRONTEND=noninteractive

# Install the required packages
RUN apt-get update -o Acquire::CompressionTypes::Order::=gz
RUN apt-get upgrade -y

RUN echo "deb http://ftp.de.debian.org/debian stable main" > /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y chromium
RUN apt-get install -y libcups2-dev 
RUN apt-get install -y libavahi-compat-libdnssd-dev 
RUN apt-get install -y gconf-service libasound2 libatk1.0-0 libcairo2 libcups2 libfontconfig1 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libxss1 fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils

RUN apt update
RUN apt-get install -y ghostscript
RUN apt-get install -y curl

# install chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN rm google-chrome-stable_current_amd64.deb

# arrange & install python things for object-tracker-python
RUN apt-get install -y python3-pip

# install usb module
RUN apt-get install libusb-1.0-0

# install cmake
RUN apt-get install -y cmake

# install node-gyp
RUN npm i node-gyp -g

WORKDIR /app

# copy application & configuration files
COPY . .

# install poco 1.8 to use doosan robot api
RUN wget https://github.com/pocoproject/poco/archive/refs/tags/poco-1.8.0-release.tar.gz && tar xvfz poco-1.8.0-release.tar.gz && \
  cd poco-poco-1.8.0-release && mkdir cmake-build && cd cmake-build  && cmake .. && cmake --build . --config Release && \
  make install
RUN cp /app/poco-poco-1.8.0-release/cmake-build/lib/libPoco* /usr/local/lib/
RUN echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/app/poco-poco-1.8.0-release/cmake-build/lib' >> ~/.bashrc && ldconfig

# install modules for python codes
RUN pip3 install -r object-tracker-python/requirements.txt

# run node install command
RUN yarn install

# Make port 3000 available to the world outside this container
EXPOSE 3000

CMD [ "yarn", "run", "serve" ]
