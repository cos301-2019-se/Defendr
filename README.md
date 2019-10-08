<img src="https://cs.up.ac.za/static/images/headerUP.jpg" alt="UP logo">

COS 301: Software Engineering
=========================

>>>>>>>>## Capstone Project
>>>>>>>># Dark nITes

---

"Technology breeds crime and we are trying... to stay one step ahead of the person trying to use it negatively." - Frank Abagnale

Defendr is designed to detect, and deflect DoS attacks and provide network load-balancing services to various backend applications and ensure their accessibility.  The DoS protection subsystem makes use of XDP and eBPF to monitor and discriminate network traffic to the backend applications.  Offending packets/IPs are dropped/blacklisted, whereas legal traffic is balanced.  Balancing will be governed by algorithms, e.g. (weighted) round-robin.  Defendr will be situated between the end-user and applications, with Direct Server Return being used to handle responses.


## **Instructions:**
If installation is required:
> - Download the repository, and navigate to it's root
> - Run **./installcommands.sh** in terminal.  Ensure the script has the requisite permission with **chmod +wrx installcommands.sh**
> - On the first window that appears, please insert **include /usr/local/lib**, save and exit

If the system is already installed:
> - Navigate to **Defendr/src/Interfaces_v2/**
> - Run the terminal command **sudo python3 main.py**

---

## Links
> -  <a href="http://darknites.co.za/pdf/Defendr%20-%20Software%20Requirements%20Specification.pdf" target="_blank">Software Requirements Specification Document</a>
> -  <a href="http://darknites.co.za/pdf/Defendr%20-%20Coding%20Standard%20.pdf" target="_blank">Coding Standard</a>
> -  <a href="http://darknites.co.za/pdf/Defendr%20-%20Testing%20Policy.pdf" target="_blank">Testing Policy</a>
> -  <a href="http://app.zenhub.com/workspaces/dark-nites-capstone-project-5cc616ec67dcfa43a66a40f3/board?repos=182156942" target="_blank">Project Management Tool</a>
> -  <a href="http://darknites.co.za/pdf/Defendr%20-%20User%20manual.pdf" target="_blank">User Manual</a>
> -  <a href="http://darknites.co.za/documents/Virtual%20Demo.pptx" target="_blank">Project presentation</a>
> -  <a href="http://darknites.co.za/documents/Demo%20Video.ppsx" target="_blank">Project video</a>
> -  <a href="http://darknites.co.za/documents" target="_blank">Research material</a>

---

### <a href="http://github.com/cos301-2019-se/Defendr/blob/master/SRS/team.md" target="_blank">Meet our Team</a> :smiley:
### <a href="http://www.darknites.co.za/" target="_blank">View our website</a>