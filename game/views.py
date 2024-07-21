from django.shortcuts import render, redirect
from django.http import JsonResponse
import json

# Define the initial game board
def initialize_board():
    return [' ' for _ in range(9)]

# View to render the game board
def index(request):
    board = initialize_board()
    if 'board' in request.session:
        board = request.session['board']
    
    return render(request, 'game/index.html', {'board': board})

# View to handle player moves
def make_move(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            index = int(data.get('index'))
            player = data.get('player')
            board = request.session.get('board', initialize_board())

            if board[index] == ' ':
                board[index] = player
                request.session['board'] = board

            winner = check_winner(board)
            if winner:
                request.session['winner'] = winner
                return JsonResponse({'status': 'game over', 'winner': winner})

            return JsonResponse({'status': 'move made', 'board': board})

        except (ValueError, TypeError, KeyError) as e:
            return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})

# Check for a winner
def check_winner(board):
    win_conditions = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8],  # Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8],  # Columns
        [0, 4, 8], [2, 4, 6]              # Diagonals
    ]

    for condition in win_conditions:
        if board[condition[0]] == board[condition[1]] == board[condition[2]] != ' ':
            return board[condition[0]]

    if ' ' not in board:
        return 'Draw'

    return None
