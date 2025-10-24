```text
 _  _  ____      ___                      _   _             
| || ||___ \ _  |_ _|_ __   ___ ___ _ __ | |_(_) ___  _ __  
| || |_ __) (_)  | || '_ \ / __/ _ \ '_ \| __| |/ _ \| '_ \ 
|__   _/ __/ _   | || | | | (_|  __/ |_) | |_| | (_) | | | |
   |_||_____(_) |___|_| |_|\___\___| .__/ \__|_|\___/|_| |_|
                                   |_|                      
```
### **Overview**

This project uses Docker and Docker Compose to run a full web service stack

---

### **Key Learning**
- Understanding how to use Docker to deploy applications

---

### **About**

👉 [**Project requirement**](\demo\en.subject.pdf)

This project uses docker and docker compose to to run a isolated container of:
- NGINX
- Wordpress
- MaraiDB

They are all connected through a shared Docker network.


---

### 📢 Commands

1. `make setup`  > 🔧 *Set up for fresh VM*
2. `make revol`  > 💣 *Recreate volume (⚠️ Data will be lost)*
3. `make re`     > 🔁 *Rebuild and run Docker containers*
4. `make hard`   > 🔨 *Full reset: Wipe volumes & images, then rebuild and run*
5. `make stop`   > ⛔ *Stop running containers*
6. `make run`    > ▶️ *Start previously stopped containers*
7. `make status` > 📊 *Check the status of containers, volumes, images & netword*

---

### 🔗 Resources


