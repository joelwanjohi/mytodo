import { View, StyleSheet, SafeAreaView, TextInput, Alert, Text, Pressable } from 'react-native';
import React, { useState } from 'react';
import firestore, { firebase } from '@react-native-firebase/firestore';
import PrimaryButton from './PrimaryButton';
import Icon from 'react-native-vector-icons/FontAwesome';
import { NativeStackScreenProps } from '@react-navigation/native-stack';

type RootStackParamList = {
    AddCustomer: { UID_Key: string };
}

type AddCustomerScreenProps = NativeStackScreenProps<RootStackParamList, "AddCustomer">

const AddCustomer = ({ route, navigation }: AddCustomerScreenProps) => {

    const [CustomerName, SetCustomerName] = useState<any | null>(null);
    const [CustomerFatherName, SetCustomerFatherName] = useState<any | null>(null);
    const [CustomerCNIC, SetCustomerCNIC] = useState<any | null>(null);
    const [CustomerAddress, SetCustomerAddress] = useState<any | null>(null);
    const [CustomerAgreementAmount, SetCustomerAgreementAmount] = useState<any | null>(null);
    const [CustomerPhone, SetCustomerPhone] = useState<any | null>(null);

    const [focusedField, setFocusedField] = useState<null | string>(null);

    const { UID_Key } = route.params;


    const HandleAddData = async () => {
        try {
            const snapshot = await firestore()
                .collection("Add_Customer_Collection")
                .where('CCNIC', '==', CustomerCNIC)
                .get();

            if (!snapshot.empty) {
                Alert.alert("This CNIC is already registered.");
                return;
            }
            await firestore().collection("Add_Customer_Collection").add({
                CName: CustomerName,
                CFatherName: CustomerFatherName,
                CCNIC: CustomerCNIC,
                CAddress: CustomerAddress,
                CAgreeAmount: CustomerAgreementAmount,
                CPhone: CustomerPhone,
                UserAccount: UID_Key,
                CustomerRemainingAmount: CustomerAgreementAmount,
                CustomerTotalAmount: CustomerAgreementAmount,
            })
            Alert.alert("Successfull", "New Customer has been added");

            SetCustomerName("");
            SetCustomerFatherName("");
            SetCustomerCNIC("");
            SetCustomerAddress("");
            SetCustomerAgreementAmount("");
            SetCustomerPhone("");

            navigation.pop();

        } catch (error) {
            console.log(error);
        }
    }


    return (
        <Pressable style={styles.loginPageContainer} onPress={() => { setFocusedField("null") }}>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="user" size={30} color={focusedField === 'name' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Name"
                    onFocus={() => setFocusedField('name')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCustomerName(value) }} value={CustomerName}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="user" size={30} color={focusedField === 'fathername' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Father Name"
                    onFocus={() => setFocusedField('fathername')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCustomerFatherName(value) }} value={CustomerFatherName}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="vcard" size={26} color={focusedField === 'vcard' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="CNIC"
                    keyboardType='numeric'
                    onFocus={() => setFocusedField('vcard')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCustomerCNIC(value) }} value={CustomerCNIC}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="home" size={30} color={focusedField === 'address' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Address"
                    onFocus={() => setFocusedField('address')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCustomerAddress(value) }} value={CustomerAddress}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="dollar" size={26} color={focusedField === 'salary' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Aggreement Amount"
                    keyboardType='numeric'
                    onFocus={() => setFocusedField('salary')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCustomerAgreementAmount(value) }} value={CustomerAgreementAmount}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="phone" size={26} color={focusedField === 'phone' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    keyboardType='numeric'
                    placeholder="Phone No."
                    onFocus={() => setFocusedField('phone')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCustomerPhone(value) }} value={CustomerPhone}
                />
            </View>

            <View style={styles.buttonContainer}>
                <PrimaryButton onPress={HandleAddData} text="Add Customer" color="black" textcolor="white" />
            </View>

        </Pressable>
    )
}

export default AddCustomer

const styles = StyleSheet.create({
    loginPageContainer: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 40,
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
    buttonContainer: {
        marginTop: 30,
        width: "100%",
    },
});