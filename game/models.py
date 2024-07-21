from django.db import models

# Create your models here.
from django.db import models

class Game(models.Model):
    board = models.JSONField(default=list)
    current_player = models.CharField(max_length=1)

    def is_valid_move(self, index):
        # Implement your move validation logic here
        pass

    def make_move(self, index):
        # Implement your move logic here
        pass

    def __str__(self):
        return f"Game with board: {self.board}"
