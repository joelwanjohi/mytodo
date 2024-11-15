import { View, Text, StyleSheet, TouchableOpacity, FlatList, Modal } from 'react-native';
import React, { useEffect, useState } from 'react';
import firestore from '@react-native-firebase/firestore';
import Icon from 'react-native-vector-icons/FontAwesome';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import PrimaryButton from './PrimaryButton';

type RootStackParamList = {
    CustomerHomeScreen: { UID_Key: string };
    CustomerDetails: { CustomerID: string };
    AssignGuards: { UID_Key: string, CUS_ID: string };
    RemoveGuards: { UID_Key: string, CUS_ID: string };
}

type DetailsScreenProps = NativeStackScreenProps<RootStackParamList, 'CustomerHomeScreen'>;

const CustomerHomeScreen = ({ route, navigation }: DetailsScreenProps) => {

    const { UID_Key } = route.params;

    const [CustomersData, SetCustomersData] = useState<any[]>([]);
    const [IsModalVisible, SetIsModalVisible] = useState(false);
    const [ItemID, SetItemID] = useState("");

    useEffect(() => {

        const fetchCustomers = () => {
            if (!UID_Key) {
                console.log("UID_KEY is not available");
                return;
            }

            const unsubscribe = firestore()
                .collection('Add_Customer_Collection')
                .where("UserAccount", '==', UID_Key)
                .onSnapshot(querySnapshot => {
                    const customData = querySnapshot.docs.map(doc => ({
                        id: doc.id,
                        ...doc.data()
                    }));

                    SetCustomersData(customData);
                }, error => {
                    console.log("Firestore error:", error);
                });

            return unsubscribe;
        };

        const unsubscribe = fetchCustomers();

        return () => {
            if (unsubscribe) {
                unsubscribe();
            }
        };
    }, [UID_Key]);

    const HandleCustomerDetails = (CustomerID: string) => {
        navigation.navigate("CustomerDetails", { CustomerID });
    }

    const HandleAssignGuards = () => {
        SetIsModalVisible(false);
        navigation.navigate("AssignGuards", { UID_Key: UID_Key, CUS_ID: ItemID });
    }

    const HandleRemoveGuards = () => {
        SetIsModalVisible(false);
        navigation.navigate("RemoveGuards", { UID_Key: UID_Key, CUS_ID: ItemID });
    }

    return (
        <View style={styles.mainContainer}>
            <FlatList
                data={CustomersData}
                keyExtractor={(item) => item.id}
                renderItem={({ item }) => (
                    <View style={styles.listcontainer}>
                        <View style={styles.dataside}>
                            <TouchableOpacity onPress={() => HandleCustomerDetails(item.id)}>
                                <Text style={styles.cardText}>Customer: <Text style={{ fontWeight: "bold" }}>{item.CName}</Text></Text>
                                <Text style={styles.cardText}>Guards: <Text style={{ fontWeight: "bold" }}>{item.AssignedGuards ? item.AssignedGuards.join(", ") : "    -"}</Text></Text>
                            </TouchableOpacity>
                        </View>
                        <TouchableOpacity onPress={() => {
                            SetItemID(item.id);
                            SetIsModalVisible(true);
                        }}>
                            <View style={styles.IconSide}>
                                <Icon name="ellipsis-v" size={40} color="#000000" style={styles.iconStyle} />
                            </View>
                        </TouchableOpacity>
                    </View>
                )}
            />
            <Modal visible={IsModalVisible} transparent={true} animationType='slide'>
                <View style={styles.modalBackground}>
                    <View style={styles.modalcontainer}>
                        <View style={styles.buttonStyle}>
                            <PrimaryButton text='Assign Guards' color='black' textcolor="white"
                                onPress={HandleAssignGuards} />
                        </View>
                        <View style={styles.buttonStyle}>
                            <PrimaryButton text='Remove Guards' color='black' textcolor="white" onPress={HandleRemoveGuards} />
                        </View>
                        <View style={styles.buttonStyle}>
                            <PrimaryButton text='Cancel' color='#ff0000' textcolor="white" onPress={() => SetIsModalVisible(false)} />
                        </View>
                    </View>
                </View>
            </Modal>
        </View>
    );
}

export default CustomerHomeScreen;

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
    },
    IconSide: {
        flex: 3,
        alignItems: "center",
        justifyContent: "center",
    },
    iconStyle: {
        marginRight: 30,
        textAlign: "center",
    },
    modalBackground: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0, 0, 0, 0.21)',
    },
    modalcontainer: {
        backgroundColor: "#ffffff",
        width: 320,
        height: 240,
        borderRadius: 25,
        justifyContent: 'center',
        alignItems: 'center',
        elevation: 40,
    },
    buttonStyle: {
        width: 230,
        marginVertical: 10,
    }
});
