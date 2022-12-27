const {readLineInterfaceOfFile} = require('./utils');

const winMoves = {
  'R': 'S',
  'P': 'R',
  'S': 'P',
};

const resultsMap = {
  'X': 'lose',
  'Y': 'draw',
  'Z': 'win',
};

const scorePerShape = {
  'R': 1,
  'P': 2,
  'S': 3,
};

const player1Map = {
  'A': 'R',
  'B': 'P',
  'C': 'S',
};

const player2Map = {
  'X': 'R',
  'Y': 'P',
  'Z': 'S',
};

function getRoundScore(p1, p2) {
  let roundScore = 0;
  if (p1 === p2) {
    roundScore = 3;
  } else if (winMoves[p2] === p1) {
    roundScore = 6;
  }
  
  return roundScore;
}

function getScorePartOne(col1, col2) {
  const p1 = player1Map[col1];
  const p2 = player2Map[col2];

  const shapeScore = scorePerShape[p2];
  const roundScore = getRoundScore(p1, p2);

  return shapeScore + roundScore;
}

function getMoveToResult(knownMove, result) {
  switch (result) {
    case 'draw':
      return knownMove;
    case 'lose':
      return winMoves[knownMove];
    case 'win':
      return winMoves[winMoves[knownMove]];
    default:
      throw new Error(`Unknown result ${result} for move ${knownMove}`);
  }
}

function getScorePartTwo(rawP1, rawResult) {
  const p1 = player1Map[rawP1];
  const result = resultsMap[rawResult];
  const p2 = getMoveToResult(p1, result);

  const shapeScore = scorePerShape[p2];
  const roundScore = getRoundScore(p1, p2);

  return shapeScore + roundScore;
}

async function main() {
  const rl = await readLineInterfaceOfFile('./day2_input');
  let scorePartOne = 0;
  let scorePartTwo = 0;

  for await (const line of rl) {
    if (line === '') {
      continue;
    }

    const [col1, col2] = line.split(' ');
    scorePartOne += getScorePartOne(col1, col2);
    scorePartTwo += getScorePartTwo(col1, col2);
  }

  console.log(`Total score by player2 (part 1): ${scorePartOne}`);
  console.log(`Total score by player2 (part 2): ${scorePartTwo}`);
}

main();
