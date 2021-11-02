FROM python:3.8

# fixing the "Release file is not valid yet" problem, see https://stackoverflow.com/questions/63526272/release-file-is-not-valid-yet-docker
RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until

RUN apt-get update && apt-get install -y git python3 python3-pip python3-venv

RUN wget https://github.com/facebook/watchman/releases/download/v2021.10.18.00/watchman-v2021.10.18.00-linux.zip -O /tmp/watchman.zip && \
	unzip /tmp/watchman.zip -d /tmp

RUN cd /tmp/watchman-v2021.10.18.00-linux && \
    mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman && \
    cp bin/* /usr/local/bin && \
    cp lib/* /usr/local/lib && \
    chmod 755 /usr/local/bin/watchman && \
    chmod 2777 /usr/local/var/run/watchman

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh -O /tmp/miniconda.sh && \
	bash /tmp/miniconda.sh -b -p $HOME/miniconda

RUN ~/miniconda/bin/conda config --remove channels defaults && \
	~/miniconda/bin/conda config --append channels conda-forge

COPY ./pyre_check.sh /root/pyre_check.sh

RUN mkdir /app

VOLUME /app/.venv

WORKDIR /app
