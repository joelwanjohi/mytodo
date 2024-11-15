import React from "react";
import { TouchableOpacity, Text, StyleSheet, GestureResponderEvent } from "react-native";

interface PrimaryButtonProps {
  text: string;
  onPress: (event: GestureResponderEvent) => void;
  color?: string; // Optional color prop
  textcolor?: string // optional color prop
}

export default function PrimaryButton({ text, onPress, color, textcolor }: PrimaryButtonProps) {
  return (
    <TouchableOpacity onPress={onPress} style={[styles.button, { backgroundColor: color || "lightgrey" }]}>
      <Text style={[styles.buttonText, {color: textcolor || "black"}]}>{text}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    padding: 12,
    borderRadius: 6,
    alignItems: "center",
  },
  buttonText: {
    color: "black",
    fontSize: 16,
    fontWeight: "bold"
  },
});
