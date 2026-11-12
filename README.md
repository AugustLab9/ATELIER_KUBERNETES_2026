# ATELIER_KUBERNETES_2026

----------------------------------------------------
Objectif : Créer un cluster simple Kubernetes (1 master + 2 workers).
+ Déployer un service Web Nginx 
Nous allons utiliser l'environnement Codespaces de GitHub
RDV https://github.com/codespaces
boris9306 — 02/02/2026 15:10
Cliquez sur “New codespace”
Repository : n’importe lequel (ou crée-en un vide)
Machine : Default (4 cores) suffit
On arrive dans VS Code dans le navigateur avec un terminal Linux prêt.
//Installer Kuber (k3d)
⁨
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
⁩
//Création du cluster Kuber
⁨
k3d cluster create lab \
  --servers 1 \
  --agents 2
⁩
//Vérification de la création de notre cluster K3d
⁨
kubectl get nodes
⁩
//Déploiement du service Nginx sur le cluster
⁨
kubectl create deployment web --image=nginx
kubectl expose deployment web --type=NodePort --port=80
kubectl get svc
⁩
boris9306 — 02/02/2026 15:19
//Forwarding de port vers l'extérieur
⁨
kubectl port-forward svc/web 8080:80 >/tmp/web.log 2>&1 &
⁩
Dans l'onglet <PORT> dans GitHub votre port 8080 est actif.
Vous pouvez lui donner une visibilité Public si vous souhaitez diffuser ce lien à l'extérieur.
boris9306 — 02/02/2026 15:30
-------------------------------------

Modifier le index.html servi par NGINX dans ton Deployment Kubernetes.
⁨⁨⁨⁨⁨
kubectl exec -it deploy/web -- bash
⁩⁩⁩⁩
⁨⁨⁨⁨
echo "Bienvenu dans mon site Web" > /usr/share/nginx/html/index.html
⁩⁩⁩
⁨⁨⁨
⁩exit
⁩⁩⁩⁩ 
--------------------------------------
Utiliser Portainer pour piloter K3s
--------------------------------------
boris9306 — 02/02/2026 15:52
// Déployer le Portainer Agent dans ton cluster k3d
⁨⁨⁨
kubectl apply -f https://downloads.portainer.io/ce2-20/portainer-agent-k8s-nodeport.yaml
⁩⁩⁩

//Vérification
⁨⁨⁨
kubectl get pods -n portainer
kubectl get svc -n portainer
⁩⁩⁩
Un service portainer-agent de type NodePort, exposé sur le port 9001

//Rendre l’agent accessible depuis Codespaces pour Portainer
⁨⁨⁨
kubectl port-forward -n portainer svc/portainer-agent 9001:9001 >/tmp/portainer-agent.log 2>&1 &
⁩⁩⁩


-----------------------------------
Installation du FrontEnd Portainer
----------------------------------
⁨⁨⁨
kubectl apply -n portainer -f https://downloads.portainer.io/ce2-20/portainer.yaml
⁩⁩⁩
⁨⁨⁨
kubectl port-forward -n portainer svc/portainer 9000:9000 >/tmp/portainer.log 2>&1 &
⁩⁩⁩
N'oubliez pas de rendre votre port public pour les "Autres"

-----------------------------------
Finalisation
----------------------------------
Depuis le FrontEnd de Portainer (Accessible depuis le port 9000)
Choisir : Add Environnements -> Kubernetes -> [Start Wizard] -> [Close]
Le cluster créé sera automatiquement détecté (grâce aux agents) 
-----------------------------------
Déploiement d'un service
----------------------------------
Nous souhaitons déployer le service "Super Mario" sur notre cluster Kuber depuis Portainer

1° - Sélectionnez votre Cluster

2° - Création une Application → [+ Create from manifest]

3° - Web editor

⁨⁨
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mario
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mario
  template:
    metadata:
      labels:
        app: mario
    spec:
      containers:
        - name: mario
          image: sevenajay/mario:latest
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: mario
spec:
  selector:
    app: mario
  ports:
    - name: http
      port: 85
      targetPort: 80
  type: ClusterIP
⁩⁩

Cliquez sur [Deploy]


//Forward du service mario sur le port 8585
⁨⁨
kubectl port-forward svc/mario 8585:85 >/tmp/mario.log 2>&1 &
⁩⁩

Travail demandé : Rendre le port 8585 public et coller l'URL de votre mario dans la discussion général de ce Discord.

Exemple : https://automatic-trout-4vp4vgqp5q37qvx-8585.app.github.dev/ 
boris9306 — 02/02/2026 16:17
--------------------------
Quelques commandes utiles
--------------------------
//Supprimer le lab K3b
⁨
k3d cluster delete lab
⁩
//Vérification
⁨
k3d cluster list
⁩
