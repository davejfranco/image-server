FROM openjdk:12-jdk-oraclelinux7 as build


RUN ["/usr/java/openjdk-12/bin/jlink", \
     "--compress=2", \
     "--strip-debug", \
     "--no-header-files", \
     "--no-man-pages", \
     "--module-path", "/usr/java/openjdk-12/jmods", \
     "--add-modules", "java.base,java.logging,jdk.unsupported", \
     "--output", "/custom-jre"]

FROM openjdk:12-jdk-oraclelinux7
COPY --from=build /custom-jre /usr/java/
ADD "app" /app
RUN mkdir /app/images \
    && mv /app/container*?jpg /app/images

CMD ["/usr/java/openjdk-12/bin/java", \
     "--upgrade-module-path", "/app", \
     "-m", "ud.examples.imageserver/ud.examples.imageserver.Server"]
