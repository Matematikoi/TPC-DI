FROM ibmjava:jre
RUN mkdir /opt/app
COPY Tools /opt/app
COPY javaDocker/generate_data.sh /generate_data.sh
RUN cp -r /opt/app/PDGF /opt/app/pdgf
