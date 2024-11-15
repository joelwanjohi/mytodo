import { View, Text, StyleSheet, FlatList, TouchableOpacity, Alert } from 'react-native';
import React, { useEffect, useState } from 'react';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import firestore from '@react-native-firebase/firestore';
import PrimaryButton from './PrimaryButton';

type RootStackParamList = {
    CustomerHomeScreen: { UID_Key: string };
    RemoveGuards: { UID_Key: string, CUS_ID: string };
}

type RemoveGuardsNativeScreenProps = NativeStackScreenProps<RootStackParamList, "RemoveGuards">;


const RemoveGuards = ({ route, navigation }: RemoveGuardsNativeScreenProps) => {

    const { UID_Key, CUS_ID } = route.params;

    const [GuardsData, SetGuardData] = useState<any[]>([]);
    const [IsAssignedButton, SetIsAssignedButton] = useState(true);

    const fetchGuards = () => {
        if (!UID_Key || !CUS_ID) {
            console.log("UID_KEY or CUS_ID is not available");
            return;
        }

        // Set up a real-time listener for the customer document
        const unsubscribe = firestore().collection('Add_Customer_Collection')
            .doc(CUS_ID)
            .onSnapshot(async doc => {
                if (doc.exists) {
                    const assignedGuardNames = doc.data()?.AssignedGuards || [];

                    // Fetch guards by their names
                    const guardsDataPromises = assignedGuardNames.map(async (name: string) => {
                        const guardSnapshot = await firestore().collection('Add_Guard_Collection')
                            .where('GName', '==', name)
                            .where('IsAssigned', '==', true)
                            .get();

                        return guardSnapshot.docs.map(doc => ({
                            id: doc.id,
                            ...doc.data()
                        }));
                    });

                    const guardsDataArrays = await Promise.all(guardsDataPromises);
                    const guardsData = guardsDataArrays.flat();

                    SetGuardData(guardsData);
                } else {
                    console.log("No such customer document!");
                }
            }, error => {
                console.log("Error fetching customer data:", error);
            });

        return unsubscribe;
    };



    useEffect(() => {
        const unsubscribe = fetchGuards();

        return () => {
            if (unsubscribe) {
                unsubscribe();
            }
        };
    }, [UID_Key, CUS_ID]);

    const HandleAssign = async (item: string) => {

        try {

            const selected_Guard_response = await firestore().collection('Add_Guard_Collection').doc(item).get();

            await firestore().collection("Add_Customer_Collection").doc(CUS_ID).update({
                AssignedGuards: firestore.FieldValue.arrayRemove(selected_Guard_response.data()?.GName),
            });

            await firestore().collection('Add_Guard_Collection').doc(item).update({
                IsAssigned: false
            });

            Alert.alert("Success", "Guard has been Un-Assigned from the Customer");
            //SetIsAssignedButton(false);
        } catch (error) {
            console.log(error);
            Alert.alert("Error", "Failed to update guard details");
        }
    }



    return (
        <View style={styles.mainContainer}>
            <FlatList
                data={GuardsData}
                keyExtractor={(item) => item.id}
                renderItem={({ item }) => (
                    <View style={styles.listcontainer}>
                        <View style={styles.dataside}>
                            <Text style={styles.cardText}>ID: {item ? item.id : "Loading"}</Text>
                            <Text style={styles.cardText}>Name: {item ? item.GName : "Loading"}</Text>
                            <Text style={styles.cardTextFather}>Father Name: {item ? item.GFName : "Loading"}</Text>
                        </View>
                        <Text></Text>
                        <View style={styles.buttonSide}>
                            <View style={styles.buttonStyle}>
                                <PrimaryButton text={IsAssignedButton ? "Un-Assign" : "Assigned"} onPress={() => {
                                    HandleAssign(item.id)
                                }} textcolor='white' color={IsAssignedButton ? "green" : "grey"}></PrimaryButton>
                            </View>
                        </View>

                    </View>
                )}
            />
        </View>
    )
}

export default RemoveGuards

const styles = StyleSheet.create({
    mainContainer: {
        paddingVertical: 8,
        paddingHorizontal: 15,
        backgroundColor: "#ececec",
        flex: 1,
    },
    listcontainer: {
        marginTop: 10,
        backgroundColor: "#ffffff",
        padding: 10,
        width: "100%",
        borderRadius: 8,
        flexDirection: "row",
    },
    cardText: {
        fontSize: 16,
        color: "black"
    },
    cardTextFather: {
        fontSize: 16,
        color: "black"
    },
    dataside: {
        //backgroundColor: "lightblue",
        flex: 5
    },
    buttonSide: {
        //backgroundColor: "#fc5bd1",
        flex: 2,
        justifyContent: "center",
        alignItems: "center"
    },
    buttonStyle: {
        width: 100,
    }
});