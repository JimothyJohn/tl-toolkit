# Choose proper base image
FROM nvcr.io/nvidia/tlt-streamanalytics:v2.0_py3

# Move to root
WORKDIR /
RUN mkdir training-data tlt-toolkit

# Install python libraries
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

# Copy application
COPY ./tlt-toolkit ./tlt-toolkit
