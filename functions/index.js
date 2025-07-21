const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendScheduledDataMessageIsTurnTonight6PM = functions
    .region("europe-west2")
    .pubsub
    .schedule("00 18 * * *")
    .timeZone("Europe/Paris")
    .onRun(async (context) => {
        const message = {
            notification: {
                title: "Ça sort ce soir ?",
                body: "Appuie sur une option pour répondre",
            },
            topic: "daily_ask_turn",
            data: {
                notificationType: "daily_reminder",
                actionType: "quick_response",
            },
            apns: {
                payload: {
                    aps: {
                        category: "DAILY_ASK_CATEGORY",
                        alert: {
                            title: "Ça sort ce soir ?",
                            body: "Appuie sur une option pour répondre",
                        },
                        sound: 'default',
                        'mutable-content': 1, // Permet les actions
                    },
                },
            },
            android: {
                notification: {
                    click_action: "DAILY_ASK_CATEGORY"
                }
            }
        };

        // Mise à jour des utilisateurs
        const usersRef = admin.firestore().collection("users");
        const snapshot = await usersRef.get();
        const batch = admin.firestore().batch();
        
        snapshot.forEach((doc) => {
            batch.update(doc.ref, {isActive: false});
        });

        try {
            // Exécuter le batch (c'était manquant !)
            await batch.commit();
            console.log("Utilisateurs mis à jour avec succès.");
            
            // Envoyer la notification
            await admin.messaging().send(message);
            console.log("Message de données envoyé avec succès.");
        } catch (error) {
            console.error("Erreur lors de l'envoi du message de données :", error);
        }
        
        return null;
    });


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

// Remove expired Turns
/*
exports.cleanupTurnCollection = functions.pubsub
  .schedule('00 16 * * *') // Cron: tous les jours à 12:00 UTC
  .timeZone('Europe/Paris') // Changer selon votre timezone
  .onRun(async (context) => {
    console.log('Starting CFQ collection cleanup...');
    
    try {
      const db = admin.firestore();
      const cfqCollection = db.collection('turns');
      
      // Calculer la date limite (24h avant maintenant)
      const now = admin.firestore.Timestamp.now();
      const twentyFourHoursAgo = new Date(now.toDate().getTime() - (24 * 60 * 60 * 1000));
      const cutoffTimestamp = admin.firestore.Timestamp.fromDate(twentyFourHoursAgo);
      
      console.log(`Deleting documents older than: ${twentyFourHoursAgo.toISOString()}`);
      
      // Query pour trouver les documents plus anciens que 24h
      // Remplacez 'createdAt' par le nom de votre champ timestamp
      const query = cfqCollection.where('timestamp', '<', cutoffTimestamp);
      const snapshot = await query.get();
      
      if (snapshot.empty) {
        console.log('No documents to delete');
        return null;
      }
      
      // Créer un batch pour supprimer plusieurs documents en une fois
      const batch = db.batch();
      let deleteCount = 0;
      
      snapshot.forEach((doc) => {
        console.log(`Marking document for deletion: ${doc.id}`);
        batch.delete(doc.ref);
        deleteCount++;
      });
      
      // Exécuter la suppression en batch
      await batch.commit();
      
      console.log(`Successfully deleted ${deleteCount} documents from CFQ collection`);
      
      return {
        success: true,
        deletedCount: deleteCount,
        timestamp: now.toDate().toISOString()
      };
      
    } catch (error) {
      console.error('Error during CFQ cleanup:', error);
      throw new functions.https.HttpsError('internal', 'Cleanup failed', error);
    }
  });
*/

// Remove expired CFQs created by user

// Remove expired Turns created by user

// Remove expired Turns

exports.cleanupTURNCollection = functions
  .region("europe-west2")
  .pubsub
  .schedule("00 14 * * *")
  .timeZone("Europe/Paris")
  .onRun(async (context) => {
    console.log('Starting TURN collection cleanup...');
    
    try {
      const db = admin.firestore();
      const turnsCollection = db.collection('turns');
      
      const now = admin.firestore.Timestamp.now();
      const twentyFourHoursAgo = new Date(now.toDate().getTime() - (24 * 60 * 60 * 1000));
      const cutoffTimestamp = admin.firestore.Timestamp.fromDate(twentyFourHoursAgo);
      
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const todayTimestamp = admin.firestore.Timestamp.fromDate(today);
        
      console.log(`Processing cleanup...`);

      const batch = db.batch();
      let deleteCount = 0;
      let conversationDeleteCount = 0;

      const queryWithEndDate = turnsCollection.where('dateEndEvent', '<', todayTimestamp);
      const snapshotWithEndDate = await queryWithEndDate.get();
      
      for (const doc of snapshotWithEndDate.docs) {
        const data = doc.data();
        console.log(`Marking TURN for deletion (expired dateEndEvent): ${doc.id}`);
        batch.delete(doc.ref);
        deleteCount++;
        
        if (data.messagerieUUID) {
          const conversationsQuery = db.collection('conversations')
            .where('uid', '==', data.messagerieUUID);
          const conversationsSnapshot = await conversationsQuery.get();
          
          conversationsSnapshot.forEach((conversationDoc) => {
            console.log(`Marking conversation for deletion: ${conversationDoc.id}`);
            batch.delete(conversationDoc.ref);
            conversationDeleteCount++;
          });
        }
      }

      const queryWithoutEndDate = turnsCollection.where('dateEndEvent', '==', "");
      const snapshotWithoutEndDate = await queryWithoutEndDate.get();
      
      for (const doc of snapshotWithoutEndDate.docs) {
        const data = doc.data();
        
        // Filtrer côté client pour le timestamp
        if (data.dateStartEvent && data.dateStartEvent < cutoffTimestamp) {
          console.log(`Marking TURN for deletion (no dateEndEvent, old creation): ${doc.id}`);
          batch.delete(doc.ref);
          deleteCount++;
          
          if (data.messagerieUUID) {
            const conversationsQuery = db.collection('conversations')
              .where('uid', '==', data.messagerieUUID);
            const conversationsSnapshot = await conversationsQuery.get();
            
            conversationsSnapshot.forEach((conversationDoc) => {
              console.log(`Marking conversation for deletion: ${conversationDoc.id}`);
              batch.delete(conversationDoc.ref);
              conversationDeleteCount++;
            });
          }
        }
      }

      if (deleteCount === 0) {
        console.log('No documents to delete');
        return null;
      }

      await batch.commit();
      
      console.log(`Successfully deleted ${deleteCount} TURNs and ${conversationDeleteCount} conversations`);
      
      return {
        success: true,
        deletedTurnCount: deleteCount,
        deletedConversationCount: conversationDeleteCount,
        timestamp: now.toDate().toISOString()
      };
      
    } catch (error) {
      console.error('Error during TURN cleanup:', error);
      throw new functions.https.HttpsError('internal', 'Cleanup failed', error);
    }
  });


// Remove expired Messagerie

// Remove expired CFQs
exports.cleanupCfqCollection = functions
  .region("europe-west2")
  .pubsub
  .schedule("00 12 * * *")
  .timeZone("Europe/Paris")
  .onRun(async (context) => {
    console.log('Starting CFQ collection cleanup...');

    try {
      const db = admin.firestore();
      const cfqCollection = db.collection('cfqs');

      // Calculer la date limite (24h avant maintenant)
      const now = admin.firestore.Timestamp.now();
      const twentyFourHoursAgo = new Date(now.toDate().getTime() - (24 * 60 * 60 * 1000));
      const cutoffTimestamp = admin.firestore.Timestamp.fromDate(twentyFourHoursAgo);

      console.log(`Deleting documents older than: ${twentyFourHoursAgo.toISOString()}`);

      // Query pour trouver les CFQs plus anciens que 24h
      const query = cfqCollection.where('timestamp', '<', cutoffTimestamp);
      const snapshot = await query.get();

      if (snapshot.empty) {
        console.log('No documents to delete');
        return null;
      }

      // Créer un batch pour supprimer CFQs et conversations
      const batch = db.batch();
      let deleteCount = 0;
      let conversationDeleteCount = 0;

      // Pour chaque CFQ à supprimer
      for (const doc of snapshot.docs) {
        const data = doc.data(); // ← Récupérer les données du document
        console.log(`Marking CFQ for deletion: ${doc.id}`);
        batch.delete(doc.ref);
        deleteCount++;
        
        // Vérifier si messagerieUUID existe avant de chercher les conversations
        if (data.messagerieUUID) {
          // Trouver et marquer les conversations associées pour suppression
          const conversationsQuery = db.collection('conversations')
            .where('eventUID', '==', data.messagerieUUID); // ← Utiliser data.messagerieUUID
          
          const conversationsSnapshot = await conversationsQuery.get();
          
          conversationsSnapshot.forEach((conversationDoc) => {
            console.log(`Marking conversation for deletion: ${conversationDoc.id}`);
            batch.delete(conversationDoc.ref);
            conversationDeleteCount++;
          });
        }
      }

      // Exécuter toutes les suppressions en une fois
      await batch.commit();

      console.log(`Successfully deleted ${deleteCount} CFQs and ${conversationDeleteCount} conversations`);

      return {
        success: true,
        deletedCfqCount: deleteCount,
        deletedConversationCount: conversationDeleteCount,
        timestamp: now.toDate().toISOString()
      };

    } catch (error) {
      console.error('Error during CFQ cleanup:', error);
      throw new functions.https.HttpsError('internal', 'Cleanup failed', error);
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
      const senderUID = newNotification.senderUID;
      const recipientUsers = notificationIdUsersSnapshot.docs.filter(doc =>
        doc.id !== senderUID && doc.data().tokenFCM
      );

      // NOUVEAU: Incrémenter messageUnreadNumber pour tous les destinataires
      const batch = admin.firestore().batch();
      
      // Pour tous les utilisateurs de la conversation SAUF l'expéditeur
      const allRecipientUsers = notificationIdUsersSnapshot.docs.filter(doc =>
        doc.id !== senderUID
      );
      
      allRecipientUsers.forEach(userDoc => {
        const userRef = admin.firestore().collection("users").doc(userDoc.id);
        batch.update(userRef, {
          arrayConversationUnread: admin.firestore.FieldValue.arrayUnion(docId)
        });
      });

      // Exécuter toutes les mises à jour en une seule transaction
      await batch.commit();

      if (recipientUsers.length === 0) {
        console.log("Aucun destinataire valide (tous sont l'expéditeur ou n'ont pas de token FCM)");
        return { success: false, message: "Aucun destinataire valide" };
      }

      // Log des tokens FCM pour vérification
      const tokens = recipientUsers.map(doc => doc.data().tokenFCM);
      console.log("Tokens FCM:", tokens);

      // Préparer les données de la notification
      const conversationId = docId;
      const content = newNotification.content || newNotification;
      const title = conversationData.titleConv;
      const words = (conversationData.lastMessage || "").split(" ");
      const messagePreview = words.length > 12 ? words.slice(0, 12).join(" ") + "..." : (conversationData.lastMessage || "");
      const body = `${conversationData?.lastMessageSender ? conversationData.lastMessageSender + ": " : ""}${messagePreview}`;

        const message = {
          notification: {
            title: title,
            body: body,
          },
          topic: "new_message",
          data: {
            conversationId: conversationId,
            conversationName: conversationData.titleConv || conversationData.title || "",
            type: "new_message"
          },
          apns: {
            payload: {
              aps: {
                alert: {
                  title: title,
                  body: body
                },
                sound: 'default'
              }
            }
          },
          tokens: tokens,
        };
        
      console.log("Message : ", message)

      // Envoyer la notification à plusieurs destinataires
      const response = await admin.messaging().sendEachForMulticast(message);

      console.log("response = ", response)
      
      if (response.failureCount > 0) {
        console.log("Échecs:", response.responses.filter(r => !r.success));
      }

      return {
        success: true,
        successCount: response.successCount,
        failureCount: response.failureCount,
        totalRecipients: tokens.length,
        arrayConversationUnreadUpdated: allRecipientUsers.length

      };

    } catch (error) {
      console.error("Erreur lors de l'envoi des notifications:", error);
      return Promise.reject(error);
    }
  });

exports.onNotificationCreated = functions
    .region("europe-west2")
    .firestore
    .document("notifications/{docId}/userNotifications/{subDocId}")
    .onCreate(async (snap, context) => {
        try {
          const newNotification = snap.data();
          const docId = context.params.docId;
        
          console.log("test", newNotification);

          const notificationIdUsersSnapshot = await admin
            .firestore()
            .collection("users")
            .where("notificationsChannelId", "==", docId)
            .get();

            let title = "";
            let body = "";

            switch (newNotification.typeNotif) {
              case "cfqCreated": {
                title = `${newNotification.userInitNotifPseudo || "CFQ ?"}`;
                body = `${newNotification.titleEvent}`;
                break;
              }
              case "turnCreated": {
                  title = `${newNotification.titleEvent || "CFQ ?"}`;
                  body = `${newNotification.userInitNotifPseudo} t'invite à son turn`;
                  break;
              }
              case "teamCreated":
                title = "Nouvelle Team";
                body = `T'es invité à rejoindre la team ${newNotification.titleEvent}`;
                break;
              case "friendRequest":
                title = "Demande d'ajout";
                body = `${newNotification.userInitNotifPseudo} veut t'ajouter à ses amis`;
                break;
              //case "attending":
                //title = content.turnName;
                //body = `${content.attendingUsername} vient à ${content.turnName}`;
                //break;
              case "followUp":
                title = content.cfqName || "CFQ ?";
                body = `${content.followerUsername} ` +
                      `suit ${content.cfqName || "CFQ"}`;
                break;
              case "acceptedFriendRequest":
                title = "Ami";
                body = `${content.userInitNotifPseudo} t'a ajouté a ses amis`;
                break;
            }

            const doc = notificationIdUsersSnapshot.docs[0];

            console.log(`@@@ Utilisateur trouvé : ${doc.id}`);
            console.log("@@@ doc :", doc);
            console.log("@@@ pseudo :", doc.data().pseudo);
            console.log("@@@ tokenFCM :", doc.data().tokenFCM);
            
            console.log(`@@@`);
            console.log("@@@ title :",title);
            console.log("@@@ body :", body);
            
            const tokenFCM = doc.data().tokenFCM;

            const userRef = admin.firestore().collection("users").doc(doc.id);
            await userRef.update({
              someNotificationUnread: true
            });
            console.log(`someNotificationUnread mis à true pour l'utilisateur ${doc.id}`);

            const message = {
              notification: {
                title: title,
                body: body,
              },
              apns: {
                payload: {
                  aps: {
                    alert: {
                      title: title,
                      body: body
                    },
                    sound: 'default'
                  }
                }
              },
              token: tokenFCM,
            };
        
        const response = await admin.messaging().send(message);

        return {
            success: true,
            successCount: response.successCount,
            failureCount: response.failureCount,
            totalRecipients: 1
        };

        } catch (error) {
            console.error("Erreur lors de l'envoi des notifications:", error);
            return Promise.reject(error);
        }
    });


/*
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
 */
