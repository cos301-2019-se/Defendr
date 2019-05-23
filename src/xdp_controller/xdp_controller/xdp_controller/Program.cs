using System;
using System.Diagnostics;
using Gtk;

namespace xdp_controller
{
    class MainClass
    {

        public static void Main(string[] args){
            XdpController controller = new XdpController();
            Application.Init();

            controller.loadXdp();
            controller.blacklistIp("1.2.3.4");
            controller.blacklistIp("5.6.7.8");
            string[] ips = controller.getIps();
            for (int i = 0; i < ips.Length; ++i)
            {
                Console.Write(ips[i]+"\n");
            }
            Window myWin = new Window("My first GTK# Application! ");
        myWin.Resize(200,200);

        //Create a label and put some text in it.
        Label myLabel = new Label();
        myLabel.Text = "Hello World!!!!";

        //Add the label to the form
        myWin.Add(myLabel);

        //Show Everything
        myWin.ShowAll();

        Application.Run();
            for (int i = 0; i < ips.Length; ++i)
            {
                controller.blacklistIp("5.6.7.8");
            }
        }
    }
}
