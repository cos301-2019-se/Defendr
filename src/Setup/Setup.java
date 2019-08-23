import java.util.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.ArrayList;
import java.io.InputStream;

/* Class for handeling setup of virtual ip's on a server
 */	
class Setup{
	
	/* Class for handeling output of different input streams
	 */	
	private static class outputPrinter extends Thread {
		InputStream is = null;
		
		/* Constructer for outputPrinter class
		 * @param is input stream for which to handle output
		 * @param type spesifies the type of input stream that is supplied
		 */
		outputPrinter(InputStream is, String type) {
			this.is = is;
		}
		
		/* Overloaded run() function for  outputPrinter class which outputs data in inputstream to terminal
		 */
		public void run() {
			String s = null;
			try {
				BufferedReader br = new BufferedReader(
						new InputStreamReader(is));
				while ((s = br.readLine()) != null) {
					System.out.println(s);
				}
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
	}
	
	/*main function for Setup class
	 * @param args[0] -- virtual ip address
	 * @param args[1] -- real ip address
	 * @param args[2] -- network device name
	 */	
	public static void main(String[] args){
		
		if(args.length != 3){
			System.out.println("Bad usage");
			System.out.println("args[0] -- virtual ip address");
			System.out.println("args[1] -- real ip address");
			System.out.println("args[2] -- network device name");
			System.exit(0);
		}
		String virtual_ip = args[0];
		String real_ip = args[1];
		String dev = args[2];
        String[] commands = {"sudo arptables -A INPUT -d "+virtual_ip+" -j DROP",
			"sudo arptables -A OUTPUT -s "+virtual_ip+" -j mangle --mangle-ip-s "+real_ip,
			"sudo ip addr add "+virtual_ip+" dev "+dev};
			
		Runtime rt = Runtime.getRuntime();
		outputPrinter errorReported, outputMessage;
		
		Process proc;
		for(int i = 0; i < commands.length;++i){
			try{
				proc = rt.exec(commands[i]);
				
				errorReported = new outputPrinter(proc.getErrorStream(), "ERROR");
				outputMessage = new outputPrinter(proc.getInputStream(), "OUTPUT");
				errorReported.start();
				outputMessage.start();
			}catch(IOException e){
				System.out.println(e);
			}
		}
		System.out.println("Virtual ip \""+virtual_ip+"\" registered on device \""+dev+"\"");

	}
	


}

