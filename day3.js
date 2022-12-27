const {readLineInterfaceOfFile} = require('./utils');

const LOWER_CASE_OFFSET = 96; // a-z: 1-26
const UPPER_CASE_OFFSET = 38; // A-Z: 27-52
    
function findSharedItem(line) {
  const halfIndex = line.length / 2;
  const left = line.slice(0, halfIndex).split('');
  const right = line.slice(halfIndex).split('');

  if (left.size !== right.size) {
    throw new Error('Wrongly splitted compartments');
  }

  const rightSet = new Set(right);
  const shared = [...new Set(left.filter(item => rightSet.has(item))).values()];

  if (!shared.length) {
    throw new Error(`${line} does not share items between ${left} and ${right}`);
  }

  if (shared.length > 1) {
    throw new Error('More than one item type is shared between compartments');
  }

  return shared[0];
}

function getPriority(item) {
  const code = item.charCodeAt();
  const offset = code >= LOWER_CASE_OFFSET ? LOWER_CASE_OFFSET : UPPER_CASE_OFFSET;
  return code - offset;
}

function findGroupBadge(rucksacks) {
  const badgeCount = rucksacks.reduce((map, rucksack) => {
    const dedupItems = [...new Set(rucksack.split(''))];
    const items = dedupItems.map((item) => ([item, (map.get(item) || 0) + 1]));
    return new Map([
      ...items,
    ]);
  }, new Map());

  const numRucksacks = rucksacks.length;
  const common = [...badgeCount.entries()].filter(([badge, occurrences]) => occurrences === numRucksacks);

  if (common.length === 0) {
    throw new Error(`No common item was found across ${rucksacks}`);
  }

  if (common.length > 1) {
    throw new Error(`${common.length} common items were found across ${rucksacks}: ${common}`);
  }

  return common[0][0];
}

async function main() {
  const rl = await readLineInterfaceOfFile('./day3_input');
  let priorities = 0;

  let groupRucksacks = [];
  let groupPriorities = 0;

  for await (const line of rl) {
    // part 1
    const item = findSharedItem(line);
    const priority = getPriority(item); 

    priorities += priority;

    // part 2
    groupRucksacks.push(line);

    if (groupRucksacks.length === 3) {
      const badge = findGroupBadge(groupRucksacks);
      groupPriorities += getPriority(badge);
    
      groupRucksacks = [];
    }
  }

  if (groupRucksacks.length) {
    const badge = findGroupBadge(groupRucksacks);
    groupPriorities += getPriority(badge);
  }

  console.log(`The sum of the priorities of the common types is ${priorities}`);

  console.log(`The sum of the group priorities is ${groupPriorities}`);
}

main();
