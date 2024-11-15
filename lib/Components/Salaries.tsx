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
    Salaries: { UID_Key: string };
}

type SalariesScreenProps = NativeStackScreenProps<RootStackParamList, 'Salaries'>;

const Salaries = ({ route }: SalariesScreenProps) => {
    const { UID_Key } = route.params;

    const Template = "WW-G-";
    const [payIdValue, setPayIdValue] = useState(0);
    const [date, setDate] = useState(new Date());
    const [open, setOpen] = useState(false);

    const [value, setValue] = useState<string | null>(null);
    const [isFocus, setIsFocus] = useState(false);
    const [collectedAmount, setCollectedAmount] = useState("");
    const [extraAmount, setExtraAmount] = useState("");
    const [selectedGuardSalary, setSelectedGuardSalary] = useState<string | null>(null);
    const [remainingAmount, setRemainingAmount] = useState<string | null>(null);
    const [totalAmountToBePaid, setTotalAmountToBePaid] = useState<string | null>(null);
    const [formattedDate, setFormattedDate] = useState<string | null>(null);
    const [formattedPaidMonth, setFormattedPaidMonth] = useState<string | null>(null);
    const [guardsData, setGuardsData] = useState<{ label: string, value: string, salary: string, remain_salary: string, Total_Amount: string }[]>([]);

    useEffect(() => {
        const unsubscribe = fetchGuards();
        return () => unsubscribe && unsubscribe();
    }, [UID_Key]);

    useEffect(() => {
        resetForm();
    }, [UID_Key]);

    const fetchGuards = () => {
        if (!UID_Key) {
            console.log("UID_KEY is not available");
            return;
        }

        const unsubscribe = firestore()
            .collection('Add_Guard_Collection')
            .where("UserAccount", '==', UID_Key)
            .onSnapshot(querySnapshot => {
                const snapdata = querySnapshot.docs.map(doc => ({
                    label: doc.data().GName,
                    value: doc.id,
                    salary: doc.data().GSalary,
                    remain_salary: doc.data().GRemainingAmount,
                    Total_Amount: doc.data().Total_tobe_paid,
                }));
                setGuardsData(snapdata);
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
        setSelectedGuardSalary(null);
        setRemainingAmount(null);
        setTotalAmountToBePaid(null);
        setIsFocus(false);
    };

    const handleSave = async () => {
        if (!value || !collectedAmount || !extraAmount || !formattedDate || !formattedPaidMonth) {
            Alert.alert("Please fill in all fields.");
            return;
        }

        const collectedAmountNum = Number(collectedAmount);
        const remainingAmountNum = Number(remainingAmount);
        const selectedGuardSalaryNum = Number(selectedGuardSalary);

        if (isNaN(collectedAmountNum) || isNaN(remainingAmountNum) || isNaN(selectedGuardSalaryNum)) {
            Alert.alert("Please enter valid numeric values.");
            return;
        }

        const updatedRemainingAmount = remainingAmountNum - collectedAmountNum;
        const updatedTotalAmount = selectedGuardSalaryNum + updatedRemainingAmount;

        try {

            const respose = await firestore().collection('All_Salaries').add({
                S_Date: formattedDate,
                ExtraAmount: extraAmount,
                GuardName: guardsData.find(g => g.value === value)?.label || '',
                Gaurd_ID: value,
                Guard_Pay_ID: Template + String(payIdValue).padStart(4, '0'),
                Guard_Salary: selectedGuardSalary,
                Guard_Paid_Month: formattedPaidMonth,
                Guard_TotalAmount: updatedTotalAmount.toString(),
                AmountPaid: collectedAmountNum.toString(),
                RemainingAmount: updatedRemainingAmount.toString(),
            });

            await firestore().collection("Add_Guard_Collection").doc(value).update({
                GRemainingAmount: updatedRemainingAmount.toString(),
                Total_tobe_paid: updatedTotalAmount.toString(),
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
            <Text style={styles.headtext}>Summary</Text>

            <Dropdown
                style={[styles.dropdown, isFocus && { borderColor: 'blue' }]}
                placeholderStyle={styles.placeholderStyle}
                selectedTextStyle={styles.selectedTextStyle}
                inputSearchStyle={styles.inputSearchStyle}
                iconStyle={styles.iconStyle}
                data={guardsData}
                search
                maxHeight={300}
                labelField="label"
                valueField="value"
                placeholder={!isFocus ? 'Select guard' : '...'}
                searchPlaceholder="Search guard..."
                activeColor='#e6e5e5'
                value={value}
                onFocus={() => setIsFocus(true)}
                onBlur={() => setIsFocus(false)}
                onChange={item => {
                    setValue(item.value);
                    setSelectedGuardSalary(item.salary);
                    setRemainingAmount(item.remain_salary);
                    setTotalAmountToBePaid((Number(item.salary) + Number(item.remain_salary)).toString());
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
                <Text style={styles.textHead}>Salary: <Text style={{ color: "red" }}>{selectedGuardSalary || 'N/A'}</Text></Text>
                <Text style={styles.textHead}>Remaining Amount: <Text style={{ color: "red" }}>{remainingAmount || 'N/A'}</Text></Text>
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

export default Salaries;

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
