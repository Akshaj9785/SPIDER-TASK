let boxes = document.querySelectorAll(".box");
let resetBtn = document.querySelector("#reset-btn");
let newGameBtn = document.querySelector("#new-btn");
let msgContainer = document.querySelector(".msg-container");
let msg = document.querySelector("#msg");
let timerElement = document.querySelector("#timer");
let turnIndicator = document.querySelector("#turn-indicator");

let turnO = true; // true for playerO, false for playerX
let count = 0; // To Track Draw
let timer;
let timerValue = 30;

const winPatterns = [
  [0, 1, 2, 3],
  [4, 5, 6, 7],
  [8, 9, 10, 11],
  [12, 13, 14, 15],
  [0, 4, 8, 12],
  [1, 5, 9, 13],
  [2, 6, 10, 14],
  [3, 7, 11, 15],
  [0, 5, 10, 15],
  [3, 6, 9, 12],
];

const resetGame = () => {
  turnO = true;
  count = 0;
  timerValue = 30;
  updateTurnIndicator();
  enableBoxes();
  msgContainer.classList.add("hide");
  resetTimer();
};

boxes.forEach((box) => {
  box.addEventListener("click", () => {
    if (turnO) {
      box.innerText = "O";
      turnO = false;
    } else {
      box.innerText = "X";
      turnO = true;
    }
    box.disabled = true;
    count++;

    let isWinner = checkWinner();

    if (count === 16 && !isWinner) {
      gameDraw();
    } else if (!isWinner) {
      updateTurnIndicator();
      resetTimer();
    }
  });
});

const gameDraw = () => {
  msg.innerText = `Game was a Draw.`;
  msgContainer.classList.remove("hide");
  disableBoxes();
  clearInterval(timer);
};

const disableBoxes = () => {
  for (let box of boxes) {
    box.disabled = true;
  }
};

const enableBoxes = () => {
  for (let box of boxes) {
    box.disabled = false;
    box.innerText = "";
  }
};

const showWinner = (winner) => {
  msg.innerText = `Congratulations, Winner is ${winner}`;
  msgContainer.classList.remove("hide");
  disableBoxes();
  clearInterval(timer);
};

const checkWinner = () => {
  for (let pattern of winPatterns) {
    let pos1Val = boxes[pattern[0]].innerText;
    let pos2Val = boxes[pattern[1]].innerText;
    let pos3Val = boxes[pattern[2]].innerText;
    let pos4Val = boxes[pattern[3]].innerText;

    if (pos1Val != "" && pos2Val != "" && pos3Val != "" && pos4Val != "") {
      if (pos1Val === pos2Val && pos2Val === pos3Val && pos3Val === pos4Val) {
        showWinner(pos1Val);
        return true;
      }
    }
  }
  return false;
};

const resetTimer = () => {
  clearInterval(timer);
  timerValue = 30;
  timerElement.innerText = timerValue;
  timer = setInterval(() => {
    timerValue--;
    timerElement.innerText = timerValue;
    if (timerValue === 0) {
      clearInterval(timer);
      turnO = !turnO; // Switch turn if time runs out
      updateTurnIndicator();
      resetTimer(); // Restart the timer for the next player
    }
  }, 1000);
};

const updateTurnIndicator = () => {
  turnIndicator.innerText = turnO ? "Player O's Turn" : "Player X's Turn";
};

newGameBtn.addEventListener("click", resetGame);
resetBtn.addEventListener("click", resetGame);

// Start the initial timer and update turn indicator
resetTimer();
updateTurnIndicator();