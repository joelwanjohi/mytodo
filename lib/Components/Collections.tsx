import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, TouchableOpacity, View, Alert } from 'react-native';
import { Dropdown } from 'react-native-element-dropdown';
import { TextInput } from 'react-native-gesture-handler';
import Icon from 'react-native-vector-icons/FontAwesome';
import PrimaryButton from './PrimaryButton';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import firestore from '@react-native-firebase/firestore';
import DatePicker from 'react-native-date-picker';

type RootStackParamList = {
    Collections: { UID_Key: string };
}

type collectionscreenprops = NativeStackScreenProps<RootStackParamList, 'Collections'>;

const Collections = ({ route }: collectionscreenprops) => {
    const { UID_Key } = route.params;

    const Template = "WW-U-";
    const [payIdValue, setPayIdValue] = useState(0);
    const [date, setDate] = useState(new Date());
    const [open, setOpen] = useState(false);

    const [value, setValue] = useState<string | null>(null);
    const [isFocus, setIsFocus] = useState(false);
    const [collectedAmount, setCollectedAmount] = useState("");
    const [extraAmount, setExtraAmount] = useState("");
    const [SelectedCustomerAgreeAmount, setSelectedCustomerAgreeAmount] = useState<string | null>(null);
    const [RemainingAgreementAmount, setRemainingAgreementAmount] = useState<string | null>(null);
    const [totalAmountToBePaid, setTotalAmountToBePaid] = useState<string | null>(null);
    const [formattedDate, setFormattedDate] = useState<string | null>(null);
    const [formattedPaidMonth, setFormattedPaidMonth] = useState<string | null>(null);
    const [customerData, setCustomersData] = useState<{ label: string, value: string, agree_amount: string, remain_agreeamount: string, Total_Amount: string }[]>([]);

    useEffect(() => {
        const unsubscribe = fetchCustomers();
        return () => unsubscribe && unsubscribe();
    }, [UID_Key]);

    useEffect(() => {
        resetForm();
    }, [UID_Key]);

    const fetchCustomers = () => {
        if (!UID_Key) {
            console.log("UID_KEY is not available");
            return;
        }

        const unsubscribe = firestore()
            .collection('Add_Customer_Collection')
            .where("UserAccount", '==', UID_Key)
            .onSnapshot(querySnapshot => {
                const snapdata = querySnapshot.docs.map(doc => ({
                    label: doc.data().CName,
                    value: doc.id,
                    agree_amount: doc.data().CAgreeAmount,
                    remain_agreeamount: doc.data().CustomerRemainingAmount,
                    Total_Amount: doc.data().CustomerTotalAmount,
                }));

                console.log("Customer Data Fetched SuccessFully");

                setCustomersData(snapdata);
            }, error => {
                console.log("Firestore error:", error);
            });

        return unsubscribe;
    };

    const resetForm = () => {
        setValue(null);
        setCollectedAmount("");
        setExtraAmount("");
        setFormattedDate(null);
        setFormattedPaidMonth(null);
        setSelectedCustomerAgreeAmount(null);
        setRemainingAgreementAmount(null);
        setTotalAmountToBePaid(null);
        setIsFocus(false);
    };

    const handleSave = async () => {
        if (!value || !collectedAmount || !extraAmount || !formattedDate || !formattedPaidMonth) {
            Alert.alert("Please fill in all fields.");
            return;
        }

        const collectedAmountNum = Number(collectedAmount);
        const RemainingAgreementAmountNum = Number(RemainingAgreementAmount);
        const SelectedCustomerAgreeAmountNum = Number(SelectedCustomerAgreeAmount);

        if (isNaN(collectedAmountNum) || isNaN(RemainingAgreementAmountNum) || isNaN(SelectedCustomerAgreeAmountNum)) {
            Alert.alert("Please enter valid numeric values.");
            return;
        }

        const updatedRemainingAgreementAmount = RemainingAgreementAmountNum - collectedAmountNum;
        const updatedTotalAmount = SelectedCustomerAgreeAmountNum + updatedRemainingAgreementAmount;

        try {

            const respose = await firestore().collection('All_Salaries').add({
                C_Date: formattedDate,
                C_ExtraAmount: extraAmount,
                CustomerName: customerData.find(g => g.value === value)?.label || '',
                CustomerID: value,
                Customer_PayID: Template + String(payIdValue).padStart(4, '0'),
                Customer_AgreeAount: SelectedCustomerAgreeAmount,
                Customer_Paid_month: formattedPaidMonth,
                Customer_total_amount: updatedTotalAmount.toString(),
                CustomerAmountPaid: collectedAmountNum.toString(),
                C_RemainingAgreementAmount: updatedRemainingAgreementAmount.toString(),
            });

            await firestore().collection("Add_Customer_Collection").doc(value).update({
                CustomerRemainingAmount: updatedRemainingAgreementAmount.toString(),
                CustomerTotalAmount: updatedTotalAmount.toString(),
                Salaries_IDs: firestore.FieldValue.arrayUnion(respose._documentPath._parts[1]),
            });

            setPayIdValue(prevValue => prevValue + 1);

            resetForm();

            Alert.alert("Data saved successfully!");
        } catch (error) {
            console.log("Error saving data:", error);
            Alert.alert("An error occurred while saving the data.");
        }
    };

    const formatDate = (date: Date, options: Intl.DateTimeFormatOptions) => {
        return date.toLocaleDateString('en-US', options).replace(',', '');
    };

    return (
        <View style={styles.mainContainer}>
            <Text style={styles.headtext}>Customer Summary</Text>

            <Dropdown
                style={[styles.dropdown, isFocus && { borderColor: 'blue' }]}
                placeholderStyle={styles.placeholderStyle}
                selectedTextStyle={styles.selectedTextStyle}
                inputSearchStyle={styles.inputSearchStyle}
                iconStyle={styles.iconStyle}
                data={customerData}
                search
                maxHeight={300}
                labelField="label"
                valueField="value"
                placeholder={!isFocus ? 'Select Customer' : '...'}
                searchPlaceholder="Search Customer..."
                activeColor='#e6e5e5'
                value={value}
                onFocus={() => setIsFocus(true)}
                onBlur={() => setIsFocus(false)}
                onChange={item => {
                    setValue(item.value);
                    setSelectedCustomerAgreeAmount(item.agree_amount);
                    setRemainingAgreementAmount(item.remain_agreeamount);
                    setTotalAmountToBePaid((Number(item.agree_amount) + Number(item.remain_agreeamount)).toString());
                    setIsFocus(false);
                }}
                renderLeftIcon={() => (
                    <Icon
                        style={styles.icon}
                        color={isFocus ? 'blue' : 'black'}
                        name="retweet"
                        size={20}
                    />
                )}
            />

            <View style={styles.amountContainer}>
                <Text style={styles.textHead}>agree_amount: <Text style={{ color: "red" }}>{SelectedCustomerAgreeAmount || 'N/A'}</Text></Text>
                <Text style={styles.textHead}>Remaining Amount: <Text style={{ color: "red" }}>{RemainingAgreementAmount || 'N/A'}</Text></Text>
                <Text style={styles.textHead}>Total Amount to be paid: <Text style={{ color: "red" }}>{totalAmountToBePaid || 'N/A'}</Text></Text>

                <Text style={styles.heading2}>Collected Amount:</Text>
                <TextInput
                    style={styles.textInput}
                    placeholder='Enter collected amount'
                    keyboardType='numeric'
                    value={collectedAmount}
                    onChangeText={setCollectedAmount}
                />

                <Text style={styles.heading2}>Extra Amount:</Text>
                <TextInput
                    style={styles.textInput}
                    placeholder='Enter the extra amount'
                    keyboardType='numeric'
                    value={extraAmount}
                    onChangeText={setExtraAmount}
                />

                <TouchableOpacity onPress={() => setOpen(true)}>
                    <Text style={[styles.heading2, { color: "blue" }]}>Select Date:</Text>
                </TouchableOpacity>
                <DatePicker
                    modal
                    open={open}
                    date={date}
                    mode='date'
                    onConfirm={(date) => {
                        setOpen(false);
                        setDate(date);
                        setFormattedDate(formatDate(date, { month: 'short', day: '2-digit', year: 'numeric' }));
                        setFormattedPaidMonth(formatDate(date, { month: 'long', year: 'numeric' }));
                    }}
                    onCancel={() => setOpen(false)}
                />
                <Text style={styles.heading3}>{formattedDate}</Text>

                <Text style={[styles.heading2, { color: "#000000" }]}>Paid Month:</Text>

                <Text style={styles.heading3}>{formattedPaidMonth}</Text>

                <View style={{ marginTop: 30 }}>
                    <PrimaryButton onPress={handleSave} text='Save' color='black' textcolor='white' />
                </View>
            </View>
        </View>
    );
};

export default Collections;

const styles = StyleSheet.create({
    mainContainer: {
        flex: 1,
        paddingTop: 10,
        backgroundColor: "white",
        alignItems: 'center',
    },
    headtext: {
        marginVertical: 30,
        fontSize: 20,
        color: "black",
        fontWeight: "bold",
    },
    dropdown: {
        height: 50,
        borderColor: '#000000',
        borderWidth: 1,
        borderRadius: 8,
        paddingHorizontal: 8,
        width: "90%",
    },
    icon: {
        padding: 10,
    },
    placeholderStyle: {
        color: "black",
        fontSize: 16,
    },
    selectedTextStyle: {
        color: "black",
        fontSize: 18,
    },
    iconStyle: {
        width: 20,
        height: 20,
    },
    inputSearchStyle: {
        height: 40,
        fontSize: 16,
    },
    textHead: {
        marginTop: 1,
        fontSize: 16,
        color: "black",
    },
    amountContainer: {
        marginTop: 15,
        width: "90%",
    },
    heading2: {
        fontSize: 18,
        color: "black",
        fontWeight: "bold",
        marginVertical: 8,
    },
    textInput: {
        borderWidth: 1,
        borderColor: "black",
        width: "100%",
        borderRadius: 8,
        padding: 10,
        fontSize: 17,
        color: "black",
        height: 50,
    },
    heading3: {
        fontSize: 16,
        color: "black",
        marginBottom: 5,
    }
});
