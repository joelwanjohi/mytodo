import { View, Text, Alert, StyleSheet, SafeAreaView, TouchableOpacity, TextInput, FlatList } from 'react-native'
import React, { useEffect, useState } from 'react'
import firestore from '@react-native-firebase/firestore';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';

type RootStackParamList = {
    CustomerDetails: { CustomerID: string };
}

type DetailsScreenProps = NativeStackScreenProps<RootStackParamList, 'CustomerDetails'>;


const CustomerDetails = ({ route, navigation }: DetailsScreenProps) => {

    const { CustomerID } = route.params;

    const [CustomerData, setCustomerData] = useState<any>(null);
    const [isEditing, setIsEditing] = useState<boolean>(false);

    const [CustomerName, SetCustomerName] = useState<string>('');
    const [CustomerFatherName, SetCustomerFatherName] = useState<string>('');
    const [CustomerCNIC, SetCustomerCNIC] = useState<string>('');
    const [CustomerAddress, SetCustomerAddress] = useState<string>('');
    const [AgreementAmount, SetAgreementAmount] = useState<string>('');
    const [CustomerPhone, SetCustomerPhone] = useState<string>('');

    const [SalaryData, SetSalaryData] = useState<any[]>([]);


    const fetchCustomerDetails = async () => {
        try {
            const CustomerDoc = await firestore().collection('Add_Customer_Collection').doc(CustomerID).get();
            if (CustomerDoc.exists) {
                const data = CustomerDoc.data();
                if (data) {

                    setCustomerData(data);

                    SetCustomerName(data.CName || '');
                    SetCustomerFatherName(data.CFatherName || '');
                    SetCustomerCNIC(data.CCNIC || '');
                    SetCustomerAddress(data.CAddress || '');
                    SetAgreementAmount(data.CAgreeAmount || '');
                    SetCustomerPhone(data.CPhone || '');
                }
            }
        } catch (error) {
            console.log(error);
        }
    };

    const fetchSalaryData = async () => {

        const unsubscribe = firestore()
            .collection("All_Salaries")
            .where("CustomerID", '==', CustomerID)
            .onSnapshot(querySnapshot => {
                const customData = querySnapshot.docs.map(doc => ({
                    id: doc.id,
                    ...doc.data()
                }));

                SetSalaryData(customData);

            }, error => {
                console.log("Firestore error:", error);
            });
    };



    useEffect(() => {
        fetchCustomerDetails();
        fetchSalaryData();
    }, []);

    const handleUpdateDetails = async () => {
        try {
            await firestore().collection('Add_Customer_Collection').doc(CustomerID).update({
                CName: CustomerName,
                CFatherName: CustomerFatherName,
                CCNIC: CustomerCNIC,
                CAddress: CustomerAddress,
                CAgreeAmount: AgreementAmount,
                CPhone: CustomerPhone,
            });
            Alert.alert("Success", "Customer details updated successfully");
            setIsEditing(false);
            fetchCustomerDetails(); // Refresh Customer details after update
        } catch (error) {
            console.log(error);
            Alert.alert("Error", "Failed to update Customer details");
        }
    };

    if (!CustomerData) {
        return (
            <View style={styles.container}>
                <Text>Loading...</Text>
            </View>
        );
    }
    const handleDeleteCustomer = async () => {
        Alert.alert(
            "Confirm Delete",
            "Are you sure you want to delete this guard?",
            [
                {
                    text: "Cancel",
                    style: "cancel"
                },
                {
                    text: "Delete",
                    style: "destructive",
                    onPress: async () => {
                        try {
                            await firestore().collection('Add_Customer_Collection').doc(CustomerID).delete();
                            Alert.alert("Deleted", "Guard has been deleted.");
                            navigation.goBack();
                        } catch (error) {
                            console.log(error);
                            Alert.alert("Error", "Failed to delete guard");
                        }
                    }
                }
            ]
        );
    };

    return (
        <SafeAreaView style={styles.container}>
            <View style={styles.topContainer}>
                <Text style={styles.headtext}>Customer Details</Text>
                <View style={styles.buttonContainer}>
                    <TouchableOpacity style={styles.editButton} onPress={() => setIsEditing(!isEditing)}>
                        <Text style={[styles.headtext, { color: "blue" }]}>
                            {isEditing ? 'Cancel' : 'Edit'}
                        </Text>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.deleteButton} onPress={handleDeleteCustomer}>
                        <Text style={[styles.headtext, { color: "red" }]}>
                            Delete
                        </Text>
                    </TouchableOpacity>
                </View>
            </View>
            {isEditing ? (
                <View>
                    <View style={styles.textInputContainer}>
                        <View style={styles.iconContainer}>
                            <Icon name="user" size={30} color="black" style={styles.icon} />
                        </View>
                        <TextInput
                            style={styles.textInputfeild}
                            placeholder="Name"
                            onChangeText={(value) => SetCustomerName(value)}
                            value={CustomerName}
                        />
                    </View>

                    <View style={styles.textInputContainer}>
                        <View style={styles.iconContainer}>
                            <Icon name="user" size={30} color="black" style={styles.icon} />
                        </View>
                        <TextInput
                            style={styles.textInputfeild}
                            placeholder="Father Name"
                            onChangeText={(value) => SetCustomerFatherName(value)}
                            value={CustomerFatherName}
                        />
                    </View>

                    <View style={styles.textInputContainer}>
                        <View style={styles.iconContainer}>
                            <Icon name="vcard" size={26} color="black" style={styles.icon} />
                        </View>
                        <TextInput
                            style={styles.textInputfeild}
                            placeholder="CustomerCNIC"
                            onChangeText={(value) => SetCustomerCNIC(value)}
                            value={CustomerCNIC}
                        />
                    </View>

                    <View style={styles.textInputContainer}>
                        <View style={styles.iconContainer}>
                            <Icon name="home" size={30} color="black" style={styles.icon} />
                        </View>
                        <TextInput
                            style={styles.textInputfeild}
                            placeholder="CustomerAddress"
                            onChangeText={(value) => SetCustomerAddress(value)}
                            value={CustomerAddress}
                        />
                    </View>

                    <View style={styles.textInputContainer}>
                        <View style={styles.iconContainer}>
                            <Icon name="dollar" size={26} color="black" style={styles.icon} />
                        </View>
                        <TextInput
                            style={styles.textInputfeild}
                            placeholder="AgreementAmount (PKR)"
                            onChangeText={(value) => SetAgreementAmount(value)}
                            value={AgreementAmount}
                        />
                    </View>

                    <View style={styles.textInputContainer}>
                        <View style={styles.iconContainer}>
                            <Icon name="phone" size={26} color="black" style={styles.icon} />
                        </View>
                        <TextInput
                            style={styles.textInputfeild}
                            placeholder="Phone Number"
                            onChangeText={(value) => SetCustomerPhone(value)}
                            value={CustomerPhone}
                        />
                    </View>

                    <TouchableOpacity style={styles.updateButton} onPress={handleUpdateDetails}>
                        <Text style={styles.updateButtonText}>Update Details</Text>
                    </TouchableOpacity>
                </View>
            ) : (
                <View>
                    <View style={styles.detaiscontainer}>
                        <View style={{ flexDirection: "row" }}>
                            <Text style={styles.detailstext}>Name: </Text>
                            <Text style={styles.dataText}>{CustomerData.CName}</Text>
                        </View>
                        <View style={{ flexDirection: "row" }}>
                            <Text style={styles.detailstext}>Father Name: </Text>
                            <Text style={styles.dataText}>{CustomerData.CFatherName}</Text>
                        </View>
                    </View>
                    <View style={styles.detaiscontainer}>
                        <View style={{ flexDirection: "row" }}>
                            <Text style={styles.detailstext}>CNIC: </Text>
                            <Text style={styles.dataText}>{CustomerData.CCNIC}</Text>
                        </View>
                        <View style={{ flexDirection: "row" }}>
                            <Text style={styles.detailstext}>Address: </Text>
                            <Text style={styles.dataText}>{CustomerData.CAddress}</Text>
                        </View>
                    </View>
                    <View style={styles.detaiscontainer}>
                        <View style={{ flexDirection: "row" }}>
                            <Text style={styles.detailstext}>Phone: </Text>
                            <Text style={styles.dataText}>{CustomerData.CPhone}</Text>
                        </View>
                        <View style={{ flexDirection: "row" }}>
                            <Text style={styles.detailstext}>Agreement Amount: </Text>
                            <Text style={styles.dataText}>{CustomerData.CAgreeAmount}</Text>
                        </View>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center', marginVertical: 10, }}>
                        <View style={styles.dividerLine} />
                        <View>
                            <Text style={styles.dividerHeading}>Salaries</Text>
                        </View>
                        <View style={styles.dividerLine} />
                    </View>
                    <FlatList
                        data={SalaryData}
                        keyExtractor={(item) => item.id}
                        renderItem={({ item }) => (
                            <TouchableOpacity onPress={
                                // () => handleGuardDetails(item.id)
                                () => { }
                            }>
                                <View style={styles.listcontainer}>
                                    <View style={styles.dataside}>
                                        <Text style={styles.cardText}>ID :
                                            <Text style={{ fontWeight: "bold" }}> {item.Customer_PayID}</Text></Text>
                                        <Text style={styles.cardText}>Paid Month :
                                            <Text style={{ fontWeight: "bold" }}> {item.Customer_Paid_month}</Text></Text>
                                        <Text style={styles.cardText}>Amount Paid :
                                            <Text style={{ fontWeight: "bold" }}> {item.CustomerAmountPaid}</Text></Text>
                                        <Text style={styles.cardText}>Remaining Amount :
                                            <Text style={{ fontWeight: "bold" }}> {item.C_RemainingAgreementAmount}</Text></Text>
                                    </View>
                                    {/* <View style={styles.IconSide}>
                                        <Icon name="ellipsis-v" size={40} color="#000000" />
                                    </View> */}
                                </View>
                            </TouchableOpacity>
                        )}
                    />
                </View>
            )}
        </SafeAreaView>
    )
}

export default CustomerDetails


const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 20,
        backgroundColor: '#e9e9e9',
    },
    buttonContainer: {
        flexDirection: "row",
        justifyContent: "space-between",
    },
    editButton: {
        backgroundColor: "#d6d6d6",
        paddingHorizontal: 15,
        paddingVertical: 5,
        borderRadius: 10,
        marginRight: 10,
    },
    deleteButton: {
        backgroundColor: "#f8d7da",
        paddingHorizontal: 15,
        paddingVertical: 5,
        borderRadius: 10,
    },
    headtext: {
        fontSize: 18,
        fontWeight: "bold",
        color: "black",
    },
    topContainer: {
        flexDirection: "row",
        justifyContent: "space-between",
        marginBottom: 30,
        alignItems: "center",
    },
    detaiscontainer: {
        flexDirection: "row",
        justifyContent: "space-between",
        marginBottom: 20,
    },
    detailstext: {
        fontSize: 15,
        fontWeight: "bold",
        color: "black",
    },
    dataText: {
        fontSize: 15,
        color: "black",
    },
    dividerHeading: {
        fontSize: 19,
        fontWeight: "bold",
        color: "black",
        paddingHorizontal: 10,
    },
    dividerLine: {
        flex: 1,
        height: 1.5,
        backgroundColor: 'black'
    },
    textInputContainer: {
        backgroundColor: "lightgrey",
        width: "100%",
        height: 50,
        flexDirection: "row",
        borderRadius: 6,
        marginBottom: 15,
        borderBottomWidth: 1.5,
        borderBottomColor: "black",
    },
    textInputfeild: {
        flex: 1,
        paddingHorizontal: 10,
        paddingVertical: 7,
        fontSize: 16,
        color: "black",
    },
    iconContainer: {
        width: 50,
        justifyContent: "center",
        alignItems: "center",
    },
    icon: {},
    updateButton: {
        backgroundColor: 'black',
        padding: 15,
        borderRadius: 10,
        alignItems: 'center',
        marginTop: 20,
    },
    updateButtonText: {
        color: 'white',
        fontSize: 18,
        fontWeight: 'bold',
    },
    cardText: {
        fontSize: 16,
        color: "black",
        marginVertical: 3,

    },
    listcontainer: {
        backgroundColor: "#ffffff",
        flex: 1,
        flexDirection: "row",
        borderRadius: 8,
        padding: 10,
        justifyContent: "space-around",
        alignItems: "center",
        paddingLeft: 20,
        marginBottom: 10,
    },
    dataside: {
        flex: 8,

    },
    IconSide: {
        flex: 2,
        alignItems: "center",
    },
    iconStyle: {

    }
});

