// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract TicTacToe {
    address player1;
    address player2;
    uint8 current_move = 0;
    enum GridState {
        Empty,
        O,
        X
    }
    GridState[3][3] board;

    constructor(address _player1, address _player2) {
        require(_player1 != address(0));
        require(_player2 != address(0));
        player1 = _player1;
        player2 = _player2; 
    }

    function playRound(uint8 yvar, uint8 xvar) public {
        require(msg.sender == player1 || msg.sender == player2, "Invalid player");
        // Check if the game has not ended
        require(!isGameEnded(), "The game has already ended");
        // Check if the sender is the current player
        require(msg.sender == existingPlayerAddress(), "Not your turn");
        require(checkGridBounds(xvar, yvar));
        // Check if the specified cell on the game board is empty
        require(board[xvar][yvar] == GridState.Empty, "Cell is already filled");

        board[xvar][yvar] = existingPlayerNumber();
        current_move = current_move + 1;
    }

    function existingPlayerAddress() public view returns (address) {
        if (current_move % 2 == 0) {
            return player1;
        } else {
            return player2;
        }
    }

    function existingPlayerNumber() public view returns (GridState) {
        if (current_move % 2 == 0) {
            return GridState.X;
        } else {
            return GridState.O;
        }
    }

    function checkWinner() public view returns (address) {
        GridState winning_num = winningPlayerNumber();
        if (winning_num == GridState.X) {
            return player1;
        } else if (winning_num == GridState.O) {
            return player2;
        }
        return payable(address(0));
    }

    function isGameEnded() public view returns (bool) {
        return (winningPlayerNumber() != GridState.Empty || current_move > 8);
    }

    function winningPlayerNumber() public view returns (GridState) {
        // Columns
        if (
            board[0][0] != GridState.Empty &&
            board[0][0] == board[0][1] &&
            board[0][0] == board[0][2]
        ) {
            return board[0][0];
        }
        if (
            board[1][0] != GridState.Empty &&
            board[1][0] == board[1][1] &&
            board[1][0] == board[1][2]
        ) {
            return board[1][0];
        }
        if (
            board[2][0] != GridState.Empty &&
            board[2][0] == board[2][1] &&
            board[2][0] == board[2][2]
        ) {
            return board[2][0];
        }
        // rows
        if (
            board[0][0] != GridState.Empty &&
            board[0][0] == board[1][0] &&
            board[0][0] == board[2][0]
        ) {
            return board[0][0];
        }
        if (
            board[0][1] != GridState.Empty &&
            board[0][1] == board[1][1] &&
            board[0][1] == board[2][1]
        ) {
            return board[0][1];
        }
        if (
            board[0][2] != GridState.Empty &&
            board[0][2] == board[1][2] &&
            board[0][2] == board[2][2]
        ) {
            return board[0][2];
        }
        // Diagonals
        if (
            board[0][0] != GridState.Empty &&
            board[0][0] == board[1][1] &&
            board[0][0] == board[2][2]
        ) {
            return board[0][0];
        }
        if (
            board[0][2] != GridState.Empty &&
            board[0][2] == board[1][1] &&
            board[0][2] == board[2][0]
        ) {
            return board[0][2];
        }
        return GridState.Empty;
    }

    function printState() public view returns (string memory) {
        string memory gameState = isGameEnded() ? getGameOverMessage() : "";
        return
            string(
                abi.encodePacked(
                    "\n",
                    printRow(0),
                    "\n",
                    printRow(1),
                    "\n",
                    printRow(2),
                    "\n",
                    gameState
                )
            );
    }

    function getGameOverMessage() internal view returns (string memory) {
        if (winningPlayerNumber() == GridState.Empty) {
            return "It's a tie!";
        } else {
            address winner = checkWinner();
            return string(abi.encodePacked("Game over! Winner: ", winner == player1 ? "Player 1" : "Player 2"));
        }
    }

    function printRow(uint8 yvar) public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    printSymbol(0, yvar),
                    "|",
                    printSymbol(1, yvar),
                    "|",
                    printSymbol(2, yvar)
                )
            );
    }
    
    function printSymbol(uint8 xvar, uint8 yvar) public view returns (string memory) {
        require(checkGridBounds(xvar, yvar));
    
        string memory squareValue;
    
        if (board[xvar][yvar] == GridState.Empty) {
            squareValue = " ";
        } else if (board[xvar][yvar] == GridState.X) {
            squareValue = "X";
        } else if (board[xvar][yvar] == GridState.O) {
            squareValue = "O";
        } else {
            // This should never happen, but if it does, return an empty string
            squareValue = "";
        }

        return string(abi.encodePacked(" ", squareValue, " "));
    }



    function checkGridBounds(uint8 xvar, uint8 yvar)
        public
        pure
        returns (bool)
    {
        return (xvar >= 0 && xvar < 3 && yvar >= 0 && yvar < 3);
    }
}
