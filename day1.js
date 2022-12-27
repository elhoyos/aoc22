const fs = require('fs');
const readline = require('node:readline');
const {readLineInterfaceOfFile} = require('./utils');

async function getCaloriesByElf() {
  const rl = await readLineInterfaceOfFile('./day1_input');
  const caloriesByElf = {}
  let elf = 1
  for await (const line of rl) {
     if (line === '') {
       elf++;
     }
     
     calories = line * 1;
     caloriesByElf[elf] = caloriesByElf[elf] ? caloriesByElf[elf] + calories : calories;
  }

  return caloriesByElf;
}


async function main() {
  const caloriesByElf = await getCaloriesByElf();
  const allCalories = Object.values(caloriesByElf);

  const maxCalories = allCalories.reduce((max, calories) => Math.max(max, calories), []);
  console.log(`Max calories carried by an elf: ${maxCalories}`);

  const sumTop3Calories = allCalories
    .slice()
    .sort((a, b) => b - a)
    .slice(0, 3)
    .reduce((sum, value) => sum + value, 0);

  console.log(`Sum of calories from the top 3 elves with more calories: ${sumTop3Calories}`);
}

main();
