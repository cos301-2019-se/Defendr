import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.HashMap;
import java.util.ArrayList;
import java.io.InputStream;

class Monitor extends Thread{  

	private static final String USER_AGENT = "Mozilla/5.0";
	private static final String GET_URL = "http://localhost:8761/eureka/apps";
	private static final String CONTENT_TYPE = "application/json; charset=utf-8";
	private static final String ACCEPT_TYPE = "application/json";
	
	class Server{
		public String ip;
		public String mac;
		public String port;
		public String app_ip;
		public boolean visited;
		
		public Server(String _ip,String _mac,String _port,String _app_ip){
			ip = _ip;
			mac = _mac;
			port = _port;
			app_ip = _app_ip;
			visited = true;
		}
	}
		
	private static JSONObject send_GET() throws IOException{
		URL obj = new URL(GET_URL);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestMethod("GET");
		con.setRequestProperty("User-Agent", USER_AGENT);
		con.setRequestProperty("Content-Type",CONTENT_TYPE);
		con.setRequestProperty("Accept",ACCEPT_TYPE);
		int responseCode = con.getResponseCode();
		System.out.println("GET Response Code :: " + responseCode);
		if (responseCode == HttpURLConnection.HTTP_OK){ 
			// success.
			BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null){
				response.append(inputLine);
			}
			in.close();			
			//System.out.println(response.toString());
			return  new JSONObject(response.toString());
		} else {
			return  new JSONObject("");
			//System.out.println("GET request not worked");
		}
	}
	
	public print_output getStreamWrapper(InputStream is, String type){
		return new print_output(is, type);
	}
	
	private class print_output extends Thread{
		InputStream is = null;
 
		print_output(InputStream is, String type){
			this.is = is;
		}
 
		public void run() {
			String s = null;
			try {
				BufferedReader br = new BufferedReader(
						new InputStreamReader(is));
				while ((s = br.readLine()) != null){
					System.out.println(s);
				}
			} catch (IOException ioe){
				ioe.printStackTrace();
			}
		}
	}

	public void run(){  
		HashMap<String,Server> servers = new HashMap<String,Server>(); 
		print_output errorReported, outputMessage;
		while(true){
			try{
				JSONObject res = send_GET();
				JSONArray apps = res.getJSONObject("applications").getJSONArray("application");
				JSONObject instance = null;
				for (int i = 0; i < apps.length(); i++) {
					JSONArray instances = apps.getJSONObject(i).getJSONArray("instance");
					for (int j = 0; j < instances.length(); j++) {
						instance = instances.getJSONObject(j);
						String mac = instance.getString("instanceId");
						if(servers.containsKey(mac)){
							servers.get(mac).visited = true;
						}else{
							Server newServer = new Server(instance.getString("ipAddr"),mac, Integer.toString(instance.getJSONObject("port").getInt("$")),instance.getString("app"));
							System.out.println("add server "+newServer.mac);
							servers.put(mac,newServer);
							Runtime rt = Runtime.getRuntime();
							System.out.println("service: "+newServer.app_ip);
							Process proc = rt.exec("sudo .././defendr_xdp_cmdline --add --service "+newServer.app_ip+" --ip " +newServer.ip+" --mac "+newServer.mac+" --port "+newServer.port);
						    errorReported = getStreamWrapper(proc.getErrorStream(), "ERROR");
							outputMessage = getStreamWrapper(proc.getInputStream(), "OUTPUT");
							errorReported.start();
							outputMessage.start();
						}
					}
				}
				ArrayList<String> toRemove = new ArrayList<String>();
				for (Server server : servers.values()) {
					if(!server.visited){
						System.out.println("remove server "+server.mac);
						toRemove.add(server.mac);
					}else{
						server.visited = false;
					}
				}
				for (String key: toRemove) {
					Server server = servers.get(key);
					Runtime rt = Runtime.getRuntime();
					Process proc = rt.exec("sudo .././defendr_xdp_cmdline --del --service "+server.app_ip+" --ip " +server.ip+" --mac "+server.mac+" --port "+server.port);
					errorReported = getStreamWrapper(proc.getErrorStream(), "ERROR");
					outputMessage = getStreamWrapper(proc.getInputStream(), "OUTPUT");
					errorReported.start();
					outputMessage.start();
					server =null;
					servers.remove(key);
				}	
				
			}catch(IOException e){
				System.out.println(e);
			}
			try{
				Thread.sleep(5000);
			}catch(InterruptedException e){
				System.out.println(e);
			}    
		}  
    }  
	public static void main(String args[]){  
		Monitor t1 = new Monitor();  
		t1.start();   
	}  
	
}  
