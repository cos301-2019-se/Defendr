package com.defender.monitoring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;

@SpringBootApplication

public class MonitoringApplication {
	private static class Worker extends Thread{
		ArrayList<String> commands;
		Process process;
		ProcessBuilder pb;
		StringBuilder out;
		BufferedReader br;
		String line;
		String previous;

		public Worker(){
			commands = new ArrayList<String>();
			process = null;
			pb = null;
			out = null;
			br = null;
			line = null;
			previous = null;
		}

		public void run (){
			System.out.println("Backend exporter has started");

			commands.add("./node_exporter");

			try{
				pb = new ProcessBuilder(commands);

				pb.directory(new File("../libs"));
				pb.redirectErrorStream(true);
				process = pb.start();

				//Read output
				out = new StringBuilder();
				br = new BufferedReader(new InputStreamReader(process.getInputStream()));
				while ((line = br.readLine()) != null)
					if (!line.equals(previous)) {
						previous = line;
						out.append(line).append('\n');
						System.out.println(line);
					} 
				//pb.directory(new File(" "));
				pb.redirectErrorStream(true);
				process = pb.start();

				//Read output
				out = new StringBuilder();
				br = new BufferedReader(new InputStreamReader(process.getInputStream()));
				while ((line = br.readLine()) != null)
					if (!line.equals(previous)) {
						previous = line;
						out.append(line).append('\n');
						System.out.println(line);
					}
			}catch(Exception e){
				System.out.println("An exception has occurred in worker thread from MonitoringApplication:\n" + e);
			}
		}
	}

	public static void main(String[] args)  throws IOException{
		SpringApplication.run(MonitoringApplication.class, args);
		try{
			Worker worker = new Worker();
			worker.start();
		}finally{
			ProcessBuilder pb = new ProcessBuilder("killall node_exporter");
			System.out.println("Back-end metrics shutdown successful");
		}
	}

}
