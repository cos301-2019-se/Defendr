using System;
using System.Diagnostics;
namespace xdp_controller
{
    public class XdpController{
        private string path;
        public XdpController(){
            path = "../../../../../";
        }
        public XdpController(string p){
            path = p;
        }

        private string ExecuteCommand(string command){
            Process proc = new System.Diagnostics.Process();
            proc.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            proc.StartInfo.FileName = "/bin/bash";
            proc.StartInfo.Arguments = "-c \" " + command + " \"";
            proc.StartInfo.UseShellExecute = false;
            proc.StartInfo.RedirectStandardOutput = true;
            proc.Start();
            string outstring = "";
            while (!proc.StandardOutput.EndOfStream){
                outstring += proc.StandardOutput.ReadLine();
            }
            return outstring;

        }

        public void loadXdp(){
            ExecuteCommand("cd " + path + " && sudo mount -t bpf bpf /sys/fs/bpf/");
            ExecuteCommand("cd " + path + " && sudo ./xdp_ddos01_blacklist --dev enp0s3 --owner $USER");

        }

        public void blacklistIp(String ip){
            ExecuteCommand("cd " + path + " && sudo ./xdp_ddos01_blacklist_cmdline --add --ip " + ip);

        }

        public void whiteListIp(String ip){
            ExecuteCommand("cd "+path+" && sudo ./xdp_ddos01_blacklist_cmdline --del --ip " + ip);

        }

        public string[] getIps(){
            string dataString = ExecuteCommand("cd " + path + " && sudo ./xdp_ddos01_blacklist_cmdline --list ");
            dataString = dataString.Replace("\"80\" : {\t\"UDP\" : 0 }","");
            dataString = dataString.Replace(" : 0", "");
            dataString = dataString.Replace(", }", "");
            dataString = dataString.Replace("{, ", "");
            dataString = dataString.Replace("\"", "");
            string[] ips = dataString.Split(',');
            for(int i = 0; i < ips.Length; ++i){
                ips[i] = ips[i].Trim();
            }
            return ips;
        }
    }
}
