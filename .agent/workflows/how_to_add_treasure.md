---
description: Steps to add a real treasure to Firestore to test the map logic
---

To see a treasure on your local map and test the "Mario" interaction, follow these steps in your Firebase Console:

1. Go to **Firestore Database**.
2. Create a collection named `treasures`.
3. Add a new Document with a random ID (or click "Auto-ID").
4. Add the following fields:
   - `id`: (String) Same as the document ID
   - `title`: (String) "Test Treasure at My Home"
   - `description`: (String) "You found the hidden Mario!"
   - `latitude`: (Number) [Your current Latitude, e.g., 30.0444]
   - `longitude`: (Number) [Your current Longitude, e.g., 31.2357]
   - `difficulty`: (String) "Easy"
   - `rewardPoints`: (Number) 100
   - `isActive`: (Boolean) true

5. Refresh your app! Mario should now appear in the "List View" or on the map coordinates.
