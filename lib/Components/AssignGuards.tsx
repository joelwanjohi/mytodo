import { View, Text, StyleSheet, FlatList, TouchableOpacity, Alert } from 'react-native';
import React, { useEffect, useState } from 'react';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import firestore from '@react-native-firebase/firestore';
import PrimaryButton from './PrimaryButton';


type RootStackParamList = {
    AssignGuards: { UID_Key: string, CUS_ID: string };
}

type AssignGuardsNativeScreenProps = NativeStackScreenProps<RootStackParamList, "AssignGuards">;


const AssignGuards = ({ route, navigation }: AssignGuardsNativeScreenProps) => {


    const { UID_Key, CUS_ID } = route.params;



    const [GuardsData, SetGuardData] = useState<any[]>([]);
    const [IsAssignedButton, SetIsAssignedButton] = useState(false);

    const fetchGuards = () => {
        if (!UID_Key) {
            console.log("UID_KEY is not available");
            return;
        }

        const unsubscribe = firestore()
            .collection('Add_Guard_Collection')
            .where("UserAccount", '==', UID_Key).where("IsAssigned", '==', false)
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


    useEffect(() => {
        const unsubscribe = fetchGuards();

        return () => {
            if (unsubscribe) {
                unsubscribe();
            }
        };
    }, [UID_Key]);

    const HandleAssign = async (item: string) => {
        try {
            const selected_Guard_response = await firestore().collection('Add_Guard_Collection').doc(item).get();
            const guardName = selected_Guard_response.data()?.GName;

            if (!guardName) {
                Alert.alert("Error", "Guard name not found");
                return;
            }

            await firestore().collection("Add_Customer_Collection").doc(CUS_ID).update({
                AssignedGuards: firestore.FieldValue.arrayUnion(guardName),
            });

            await firestore().collection('Add_Guard_Collection').doc(item).update({
                IsAssigned: true
            });

            Alert.alert("Success", "Guard has been Assigned to the Customer");
            // SetIsAssignedButton(true);
        } catch (error) {
            console.log(error);
            Alert.alert("Error", "Failed to update guard details");
        }
    };



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
                                <PrimaryButton text={IsAssignedButton ? "Assigned" : "Assign"} onPress={() => {
                                    HandleAssign(item.id)
                                }} textcolor='white' color={IsAssignedButton ? "grey" : "green"}></PrimaryButton>
                            </View>
                        </View>

                    </View>
                )}
            />
        </View>
    )
}

export default AssignGuards


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