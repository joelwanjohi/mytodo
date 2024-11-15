import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, FlatList, StyleSheet } from 'react-native';
import firestore from '@react-native-firebase/firestore';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';


type RootStackParamList = {
  Login: undefined;
  GuardDrawer: undefined;
  AddGuard: undefined;
  GuardPage: { UID_Key: string };
  GuardDetails: { guardId: string };
};

type GuardHomeScreenProps = NativeStackScreenProps<RootStackParamList, 'GuardPage'>;

function GuardPage({ route, navigation }: GuardHomeScreenProps) {
  const { UID_Key } = route.params;

  const [GuardsData, SetGuardData] = useState<any[]>([]);

  useEffect(() => {
    const fetchGuards = () => {
      if (!UID_Key) {
        console.log("UID_KEY is not available");
        return;
      }

      const unsubscribe = firestore()
        .collection('Add_Guard_Collection')
        .where("UserAccount", '==', UID_Key)
        .onSnapshot(querySnapshot => {
          const guardsData = querySnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
          }));

          SetGuardData(guardsData);
        }, error => {
          console.log("Firestore error:", error);
        });

      // Cleanup subscription on unmount
      return unsubscribe;
    };

    const unsubscribe = fetchGuards();

    // Cleanup function
    return () => {
      if (unsubscribe) {
        unsubscribe();
      }
    };
  }, [UID_Key]);

  const handleGuardDetails = (guardId: string) => {
    navigation.navigate("GuardDetails", { guardId });
  }

  return (
    <View style={styles.mainContainer}>
      <FlatList
        data={GuardsData}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <TouchableOpacity onPress={() => handleGuardDetails(item.id)}>
            <View style={styles.listcontainer}>
              <View style={styles.dataside}>
                <Text style={styles.cardText}>Guard Name: <Text style={{ fontWeight: "bold" }}>{item.GName}</Text></Text>
                <Text style={styles.cardText}>Father Name: <Text style={{ fontWeight: "bold" }}>{item.GFName}</Text></Text>
              </View>
              <View style={styles.IconSide}>
                <Text style={{ fontSize: 15, color: "black", marginBottom: 5, fontWeight: "bold" }}>Assign Status</Text>
                {item.IsAssigned ? <Icon name="check" size={20} color="#75c675" style={styles.iconStyle} /> : <Icon name="close" size={20} color="#c07e7e" style={styles.iconStyle} />}
              </View>

            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  mainContainer: {
    paddingVertical: 8,
    paddingHorizontal: 15,
    backgroundColor: "#e9e9e9",
    flex: 1,
  },
  listcontainer: {
    marginTop: 10,
    backgroundColor: "#ffffff",
    padding: 15,
    width: "100%",
    borderRadius: 8,
    flexDirection: "row",
  },
  cardText: {
    fontSize: 17,
    color: "black",
    marginTop: 7,

  },
  dataside: {
    flex: 6,
    //backgroundColor: "lightblue"
  },
  IconSide: {
    //backgroundColor: "#80ff25",
    flex: 3,
    alignItems: "center",
  },
  iconStyle: {
    backgroundColor: "#f5f5f5",
    padding: 8,
    borderRadius: 50,
    width: 40,
    height: 40,
    textAlign: "center"

  }
});

export default GuardPage;
