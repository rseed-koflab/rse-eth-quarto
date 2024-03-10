FROM rocker/verse:4.3.1

RUN apt-get update && apt-get install -y \
  && rm -rf /var/lib/apt/lists/*
  
RUN install2.r shiny

COPY renv.lock /project/renv.lock
WORKDIR /project
RUN R -e "renv::restore()"
WORKDIR /
  
COPY ./app/ /project/app

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp(port=3838, host='0.0.0.0', '/project/app')"]