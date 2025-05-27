const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

// Initialisation de Firebase Admin SDK
admin.initializeApp();

// Fonction planifiée pour s'exécuter toutes les 10 minutes

/*
exports.updateUserIsActive2PM = functions
    .region("europe-west2")
    .pubsub
    .schedule("00 14 * * *")
    .timeZone("Europe/Paris")
    .onRun(async (context) => {
      try {
        const usersRef = admin.firestore().collection("users");
        const snapshot = await usersRef.get();

        if (snapshot.empty) {
          console.log("Aucun utilisateur trouvé.");
          return null;
        }

        const batch = admin.firestore().batch();
        snapshot.forEach((doc) => {
          batch.update(doc.ref, {isActive: false});
        });

        await batch.commit();

        console.log("Mise à jour réussie pour tous les utilisateurs.");
        return null;
      } catch (error) {
        console.error("Erreur lors de la mise à jour :", error);
        throw new Error("Erreur lors de la mise à jour des utilisateurs.");
      }
    });
*/

exports.sendScheduledDataMessageIsTurnTonight6PM = functions
    .region("europe-west2")
    .pubsub
    .schedule("00 12 * * *")
    .timeZone("Europe/Paris")
    .onRun(async (context) => {
        const message = {
            notification: {
                title: "Ça sort ce soir ?",
                body: "Reste appuyé sur la notif pour répondre",
            },
            topic: "daily_ask_turn",
            data: {
                notificationType: "daily_reminder",
            },
            apns: {
                payload: {
                    aps: {
                        category: "CUSTOM_CATEGORY",
                        alert: {
                            title: "Ça sort ce soir ?",
                            body: "Reste appuyé sur la notif pour répondre",
                        },
                        sound: "silverWind.caf",
                    },
                },
            },
        };

        const usersRef = admin.firestore().collection("users");
        const snapshot = await usersRef.get();
        const batch = admin.firestore().batch();
        snapshot.forEach((doc) => {
        batch.update(doc.ref, {isActive: false});
    });

    try {
        await admin.messaging().send(message);
        console.log("Message de données envoyé avec succès.");
    } catch (error) {
        console.error("Erreur lors de l’envoi du message de données :", error);
    }

    return null;
});

/*
exports.sendScheduledMessage4AMIfTurnAlready = functions
    .region("europe-west2")
    .pubsub
    .schedule("00 4 * * *")
    .timeZone("Europe/Paris")
    .onRun(async (context) => {
      const activeUsersSnapshot = await admin
          .firestore()
          .collection("users")
          .where("isActive", "==", true)
          .get();

      for (const doc of activeUsersSnapshot.docs) {
        const userData = doc.data();
        const userRef = doc.ref;

        if (userData.tokenFCM) {
          const message = {
            notification: {
              title: "Toujours chaud ou tu rentres ?",
              body: "Va activer le switch sur ton profil " +
                    "si tu es toujours en Turn",
            },
            token: userData.tokenFCM,
          };

          try {
            const response = await admin.messaging().send(message);
            console.log(`Message envoyé à ${userData.username} avec succès :`,
                response);

            // Met à jour isActive à false après l'envoi du message
            await userRef.update({isActive: false});
            console.log(`isActive mis à false pour ${userData.username}`);
          } catch (error) {
            console.error(`Erreur pour ${userData.username} :`, error);
          }
        }
      }
    });
*/

exports.onNotificationCreated = functions
    .region("europe-west2")
    .firestore
    .document("notifications/{docId}/userNotifications/{subDocId}")
    .onCreate(async (snap, context) => {
      try {
        const newNotification = snap.data();
        const docId = context.params.docId;

        const notificationIdUsersSnapshot = await admin
            .firestore()
            .collection("users")
            .where("notificationsChannelId", "==", docId)
            .get();

        const doc = notificationIdUsersSnapshot.docs[0];
        console.log(`@@@ Utilisateur trouvé : ${doc.id}`);
        console.log("@@@ username :", doc.data().username);

        const tokenFCM = doc.data().tokenFCM;

        let title = "";
        let body = "";
        const conversationId = newNotification.content.conversationId;

        const content = newNotification.content;
        switch (newNotification.type) {
          case "message": {
            title = `Messages sur ${content.conversationName || "CFQ ?"}`;
            const words = content.messageContent.split(" ");
            const messagePreview = words.length > 3 ?
                words.slice(0, 3).join(" ") + "..." :
                content.messageContent;
            body = `${content.senderUsername}: ${messagePreview}`;
            break;
          }
          case "teamRequest":
            title = "Nouvelle Team";
            body = `T'es invité à rejoindre la team ${content.teamName}`;
            break;
          case "friendRequest":
            title = "Demande d'ajout";
            body = `${content.requesterUsername} veut t'ajouter`;
            break;
          case "eventInvitation":
            if (content.isTurn) {
              title = content.eventName;
              body = `${content.organizerUsername} t'invite à son turn`;
            } else {
              title = content.eventName || "CFQ ?";
              body = `${content.organizerUsername} a posté un CFQ`;
            }
            break;
          case "attending":
            title = content.turnName;
            body = `${content.attendingUsername} vient à ${content.turnName}`;
            break;
          case "followUp":
            title = content.cfqName || "CFQ ?";
            body = `${content.followerUsername} ` +
                  `suit ${content.cfqName || "CFQ"}`;
            break;
          case "acceptedTeamRequest":
            title = content.teamName;
            body = `${content.accepterUsername} a rejoint la team`;
            break;
          case "acceptedFriendRequest":
            title = "Ami";
            body = `${content.accepterUsername} t'a ajouté a ses amis`;
            break;
        }
        const message = {
          notification: {
            title: title,
            body: body,
          },
          data: {
            conversationId: conversationId,
          },
          token: tokenFCM,
        };
        console.log("message", message);
        const response = await admin.messaging().send(message);
        return {success: true, messageId: response};
      } catch (error) {
        console.error("Erreur :", error);
        return Promise.reject(error);
      }
    });


exports.onCreateMessage = functions
  .region("europe-west2")
  .firestore
  .document("conversations/{docId}/messages/{subDocId}")
  .onCreate(async (snap, context) => {
    try {
      const newNotification = snap.data();
      const docId = context.params.docId;

      // Récupérer les informations de la conversation
      const conversationDoc = await admin
        .firestore()
        .collection("conversations")
        .doc(docId)
        .get();

      if (!conversationDoc.exists) {
        console.log("Conversation non trouvée");
        return { success: false, message: "Conversation non trouvée" };
      }

      const conversationData = conversationDoc.data();

      // Récupérer TOUS les utilisateurs de la conversation
      // messagesChannelId est un tableau, donc on utilise array-contains
      const notificationIdUsersSnapshot = await admin
        .firestore()
        .collection("users")
        .where("messagesChannelId", "array-contains", docId)
        .get();

      if (notificationIdUsersSnapshot.empty) {
        console.log("Aucun utilisateur trouvé pour cette conversation");
        return { success: false, message: "Aucun utilisateur trouvé" };
      }

      // Filtrer pour exclure l'expéditeur du message
      const senderUID = newNotification.senderUID; // ou le champ qui contient l'ID de l'expéditeur
      const recipientUsers = notificationIdUsersSnapshot.docs.filter(doc =>
        doc.id !== senderUID && doc.data().tokenFCM // Exclure l'expéditeur ET vérifier que le token FCM existe
      );

      if (recipientUsers.length === 0) {
        console.log("Aucun destinataire valide (tous sont l'expéditeur ou n'ont pas de token FCM)");
        return { success: false, message: "Aucun destinataire valide" };
      }

      // Préparer les données de la notification en utilisant les données de la conversation
      const conversationId = docId;
      const content = newNotification.content || newNotification;
      
      // Utiliser le nom de la conversation depuis les données récupérées
      const title = conversationData.titleConv;
      const words = (conversationData.lastMessage || "").split(" ");
      const messagePreview = words.length > 12 ? words.slice(0, 12).join(" ") + "..." : (conversationData.lastMessage || "");
      const body = `${conversationData?.lastMessageSender ? conversationData.lastMessageSender + ": " : ""}${messagePreview}`;


      // Créer un tableau de tokens pour l'envoi en batch
      const tokens = recipientUsers.map(doc => doc.data().tokenFCM);

      const message = {
        notification: {
          title: title,
          body: body,
        },
        topic: "new_message",
        data: {
          conversationId: conversationId,
          conversationName: conversationData.name || conversationData.title || "",
          type: "new_message" // Utile pour gérer différents types de notifications côté client
        },
        tokens: tokens, // Utiliser 'tokens' au lieu de 'token' pour l'envoi multiple
      };

      // Envoyer la notification à plusieurs destinataires
      const response = await admin.messaging().sendEachForMulticast(message);
      
      if (response.failureCount > 0) {
        console.log("Échecs:", response.responses.filter(r => !r.success));
      }

      return {
        success: true,
        successCount: response.successCount,
        failureCount: response.failureCount,
        totalRecipients: tokens.length
      };

    } catch (error) {
      console.error("Erreur lors de l'envoi des notifications:", error);
      return Promise.reject(error);
    }
  });
