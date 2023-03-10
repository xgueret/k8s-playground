package com.xgt.labs.task.helloworld;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@Slf4j
public class HelloworldApplication implements CommandLineRunner {

    public static void main(String[] args) {
        log.info("STARTING THE APPLICATION");
        SpringApplication.run(HelloworldApplication.class, args);
        log.info("APPLICATION FINISHED");

    }

    @Override
    public void run(String... args) throws Exception {
        log.info("Hello, xgtlabs laboratory workers!!");
    }
}
