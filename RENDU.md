# Rendu — Atelier Kubernetes

> Complétez ce fichier au fil de l'atelier, puis faites un commit et un push (voir la section « Rendu » du README).

**Nom / Prénom :**
**Groupe :**

---

## Exercice 1 — Cluster

1. Combien de nœuds affiche `kubectl get nodes` ? Quel est le rôle de chacun ?
   3 nœuds : 1 control-plane qui pilote le cluster, et 2 workers qui font tourner les applications.
2. Que montre `docker ps` ? Qu'est-ce qu'un « nœud » dans k3d, concrètement ?
   docker ps montre les nœuds sous forme de conteneurs. Dans k3d, un nœud est un conteneur Docker.

## Exercice 2 — Premier déploiement

3. Quels objets Kubernetes ont été créés par `kubectl create deployment` ? (indice : `kubectl get all`)
   Un Deployment, un ReplicaSet et un Pod.
4. Vous avez supprimé le pod `web-...` : que s'est-il passé, et pourquoi ?
   Kubernetes a recréé tout de suite un nouveau pod avec un autre nom, parce que le Deployment veut toujours 1 pod en marche

## Exercice 3 — Modifier un conteneur en direct

5. Après suppression du pod, votre message « Bienvenue... » a-t-il survécu ? Pourquoi ?
   Non, le message a disparu. Il était écrit dans le conteneur, et le nouveau pod repart de l’image nginx d’origine.
6. Pourquoi le `port-forward` a-t-il cessé de fonctionner après la suppression du pod ?
   Parce que le tunnel était relié à l’ancien pod. Quand ce pod est supprimé, le tunnel est coupé.

## Exercice 4 — Déclaratif

7. Quelle différence entre `kubectl create` et `kubectl apply` ?
   kubectl create crée un objet avec une commande, une seule fois. kubectl apply lit un fichier YAML et met le cluster dans l’état décrit, on peut le relancer après chaque modification.
8. À quoi sert le `selector` d'un Service ? Que se passe-t-il s'il ne correspond à aucun pod ?
   Le selector dit au Service vers quels pods envoyer le trafic, grâce à leurs labels. S’il ne correspond à aucun pod, le trafic ne va nulle part et le site ne répond pas.

## Exercice 5 — Scaling & mises à jour

9. Sur quels nœuds se trouvent vos 3 réplicas ? Collez la sortie de `kubectl get pods -l app=site -o wide`.
   NAME                    READY   STATUS    RESTARTS   AGE     IP          NODE               NOMINATED NODE   READINESS GATES
site-5cc664db9c-2klc6   1/1     Running   0          3m2s    10.42.0.7   k3d-lab-agent-0    <none>           <none>
site-5cc664db9c-gnfss   1/1     Running   0          2m47s   10.42.2.8   k3d-lab-server-0   <none>           <none>
site-5cc664db9c-pkkj7   1/1     Running   0          2m54s   10.42.1.8   k3d-lab-agent-1    <none>           <none>
Les 3 réplicas sont répartis sur les 3 nœuds : k3d-lab-agent-0, k3d-lab-agent-1 et k3d-lab-server-0.
10. Avec l'image `nginx:9.99`, quel statut avait le pod ? Quelle commande vous a donné la cause ?
    Le pod avait le statut ImagePullBackOff. La commande kubectl describe pod donne la cause dans la section Events : l’image nginx:9.99 n’existe pas, donc Kubernetes n’arrive pas à la télécharger.
11. Pendant la panne, le site restait-il accessible ? Pourquoi ?
    Oui, le site restait accessible. Kubernetes garde les 3 anciens pods en marche tant que le nouveau n’est pas prêt, donc ils continuent de répondre.

## Exercice 6 — Portainer & Mario

12. URL publique de votre Mario :
    https://zany-train-7vgx67gjrjj92x459-8585.app.github.dev/
13. Retrouvez le Deployment `mario` en ligne de commande. Portainer et `kubectl` parlent-ils au même composant ? Lequel ?
    Oui, Portainer et kubectl parlent au même composant : l'API Server du cluster. C'est pour ça que le Deployment mario créé dans Portainer est visible avec kubectl get deploy mario.

## Bonus (facultatif)

14. Bonus réalisés et remarques :
    >

---

**Score obtenu avec `./scripts/check.sh` :** ... / ...
