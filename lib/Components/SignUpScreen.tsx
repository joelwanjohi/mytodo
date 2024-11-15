import React, { useId, useState } from "react";
import { SafeAreaView, StyleSheet, TextInput, View, Alert } from "react-native";
import PrimaryButton from "../Components/PrimaryButton";
import Icon from 'react-native-vector-icons/FontAwesome';
import auth from '@react-native-firebase/auth';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import firestore, { serverTimestamp } from '@react-native-firebase/firestore';

type RootStackParamList = {
    SignUp: undefined;
    Login: undefined;
};

type SignUpScreenProps = NativeStackScreenProps<RootStackParamList, 'SignUp'>;


function SignUpScreen({ navigation }: SignUpScreenProps) {
    const [focusedField, setFocusedField] = useState<null | string>(null);

    const [Name, SetName] = useState<any | null>(null);
    const [Email, SetEmail] = useState<any | null>(null);
    const [Password, SetPassword] = useState<any | null>(null);

    const handleSignup = async () => {


        if (Email != null && Password != null) {
            await auth().createUserWithEmailAndPassword(Email, Password).then((response) => {

                if (response) {

                    const userDocument = firestore().collection('All_Users').doc(response.user.uid).set({
                        UserName: Name,
                        UserEmail: Email,
                        UserPassword: Password,
                        TimeStamp: new Date().toLocaleString(),
                    })
                    console.log(userDocument);

                    console.log("New Signup Successfull");

                }
                Alert.alert("Success", "User Account Created !")
                navigation.navigate("Login");


            })
                .catch(error => {
                    if (error.code === 'auth/email-already-in-use') {
                        Alert.alert("Email Already in-Use", "That email address is already in use!")
                    }

                    if (error.code === 'auth/invalid-email') {
                        Alert.alert("Invalid Email", "That email address is invalid!")
                    }

                    if (error.code === 'auth/weak-password') {
                        Alert.alert("Weak Password", "Password should be at least 6 characters")
                    }
                    console.error(error);
                });
        }
        else {
            Alert.alert("Enter Email & Password First")
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
                    onChangeText={(value) => { SetName(value) }}
                    value={Name}

                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="envelope" size={26} color={focusedField === 'email' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Email"
                    onFocus={() => setFocusedField('email')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetEmail(value) }}
                    value={Email}
                />
            </View>

            <View style={styles.textInputContainer}>
                <View style={styles.iconContainer}>
                    <Icon name="lock" size={30} color={focusedField === 'pass' ? 'blue' : 'black'} style={styles.icon} />
                </View>
                <TextInput
                    style={styles.textInputfeild}
                    placeholder="Password"
                    secureTextEntry={true}
                    onFocus={() => setFocusedField('pass')}
                    onBlur={() => setFocusedField(null)}
                    onChangeText={(value) => { SetPassword(value) }}
                    value={Password}
                />
            </View>

            <View style={styles.buttonContainer}>
                <PrimaryButton onPress={handleSignup} text="Sign Up" color="black" textcolor="white" />
            </View>
        </SafeAreaView>
    );
}

export default SignUpScreen;

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
        // borderRightColor: "black",
        // borderRightWidth: 2,
    },
    icon: {
        //paddingRight: 15,
    },
    buttonContainer: {
        marginTop: 30,
        width: "100%",
    },
});
