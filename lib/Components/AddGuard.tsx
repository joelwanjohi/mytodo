import { View, StyleSheet, SafeAreaView, TextInput, Alert } from 'react-native';
import React, { useState } from 'react';
import firestore from '@react-native-firebase/firestore';
import PrimaryButton from './PrimaryButton';
import Icon from 'react-native-vector-icons/FontAwesome';
import { NativeStackScreenProps } from '@react-navigation/native-stack';


type RootStackParamList = {
    GuardDrawer: { UID_Key: string };
    AddGuard: { UID_Key: string };
};


type AddGuardPageProps = NativeStackScreenProps<RootStackParamList, 'AddGuard'>;


const AddGuard = ({ route, navigation }: AddGuardPageProps) => {

    const { UID_Key } = route.params;

    const [GuardName, SetguardName] = useState<any | null>(null);
    const [FatherName, SetFatherName] = useState<any | null>(null);
    const [CNIC, SetCNIC] = useState<any | null>(null);
    const [Address, SetAddress] = useState<any | null>(null);
    const [Salary, SetSalary] = useState<any | null>(null);
    const [Phone, Setphone] = useState<any | null>(null);

    const [focusedField, setFocusedField] = useState<null | string>(null);

    const HandleAddData = async () => {
        try {
            const snapshot = await firestore()
                .collection("Add_Guard_Collection")
                .where('GCNIC', '==', CNIC)
                .get();

            if (!snapshot.empty) {
                Alert.alert("This CNIC is already registered.");
                return;
            }

            await firestore()
                .collection("Add_Guard_Collection")
                .add({
                    GName: GuardName,
                    GFName: FatherName,
                    GCNIC: CNIC,
                    GAddress: Address,
                    GSalary: Salary,
                    GPhone: Phone,
                    UserAccount: UID_Key,
                    IsAssigned: false,
                    GRemainingAmount: Salary,
                    Total_tobe_paid: Salary,
                });

            Alert.alert("Guard Added to Firebase!");

            SetguardName("");
            SetFatherName("");
            SetCNIC("");
            SetAddress("");
            SetSalary("");
            Setphone("");

            navigation.navigate("GuardDrawer", { UID_Key: UID_Key });



            //GetDatabase();
        } catch (error) {
            console.log(error);
        }
    }


    return (
        <SafeAreaView style={styles.loginPageContainer}>
            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="user" size={30} color={focusedField === 'name' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Name"
                    onFocus={() => setFocusedField('name')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetguardName(value) }} value={GuardName}
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
                    onChangeText={(value) => { SetFatherName(value) }} value={FatherName}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="vcard" size={26} color={focusedField === 'vcard' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="CNIC"
                    onFocus={() => setFocusedField('vcard')}
                    keyboardType='numeric'
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetCNIC(value) }} value={CNIC}
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
                    onChangeText={(value) => { SetAddress(value) }} value={Address}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="dollar" size={26} color={focusedField === 'salary' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    keyboardType='numeric'
                    placeholder="Salary (PKR)"
                    onFocus={() => setFocusedField('salary')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetSalary(value) }} value={Salary}
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
                    onChangeText={(value) => { Setphone(value) }} value={Phone}
                />
            </View>

            <View style={styles.buttonContainer}>
                <PrimaryButton onPress={HandleAddData} text="Add Guard" color="black" textcolor="white" />
            </View>
        </SafeAreaView>
    );
};

const styles = StyleSheet.create({
    loginPageContainer: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 40,
        backgroundColor: "white"
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

export default AddGuard;
