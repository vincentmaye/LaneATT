FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel

RUN apt-get update && apt-get install -y openssh-client openssh-server git libsm6 libxext6 libxrender-dev

RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

RUN git config --global user.email "vincent.mayer@tum.de" && git config --global user.name "Vincent Mayer"

RUN mkdir -p -m 0700 ~/.ssh && \
    echo "\
Host github.com \
    HostName github.com \
    StrictHostKeyChecking no \
    UserKnownHostsFile /dev/null \
" >> ~/.ssh/config

ADD . /LaneATT

WORKDIR /LaneATT

RUN pip install -r requirements.txt 
RUN cd lib/nms; python setup.py install; cd -
