import pygame

from random import randint

# general setup
pygame.init() # this initializes the pygame and it is very important for everything to run properly means with this there's not much need to worry about the details.
WINDOW_WIDTH, WINDOW_HEIGHT= 1280,720
display_surface = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT)) # with this now when we run the code we will see a window creating and that is the intented experience, what is happening now is that we areimporting pygame we are initializing it and then we are creating a window but after that the code is ending hence everything disappears including the window because of that we can only see the window for a fraction of a second and to fix that we have to make sure that this code runs forever or atleast until we want to close it intentionally which we are going to do via a while loop.
pygame.display.set_caption('Space Shooter')
running= True # default true statement for the game.

# Plain Surface
surf = pygame.Surface((100,200))
surf.fill('orange')
x = 100

# Importing an Image
player_surf = pygame.image.load('C:/Users/user/OneDrive/Desktop/python programming/5games-main/5games-main/space shooter/images/player.png').convert_alpha()
player_rect = player_surf.get_frect(center= (WINDOW_WIDTH/2, WINDOW_HEIGHT/2))  # frect:floating point rectangle

star_surf = pygame.image.load('C:/Users/user/OneDrive/Desktop/python programming/5games-main/5games-main/space shooter/images/star.png').convert_alpha()
star_positions = [(randint(0, WINDOW_WIDTH),(randint(0,WINDOW_HEIGHT))) for i in range(20)]

while running:
    # event loop (created to acutally close the game)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False # this for if the if statement triggers.

    # draw the game
    display_surface.fill('grey') # First goes the surface, then star and then player images.
    for pos in star_positions:
        display_surface.blit(star_surf, pos)
    player_rect.left += 0.1
    display_surface.blit(player_surf, player_rect)
    pygame.display.update() # This takes all of the elements that we have run in the while loop before and then draws them on the display.

pygame.quit() # this method is essentially the opposite of pygame.init() meaning it uninitializes everything so we are here making sure that we are closing the game properly. most of the times if we forget this it will not cause many issues but sometimes it can cause a bug or atleast weird behaviour so it's better to include this. and this would be the most common way for a very basic pygame setup, which means after that we want to draw the elements of the game. and for that we have to call one method which is called pygame.dispaly.flip() or pygame.display.update() as for update this will update the entire window and for the flip we can specify that we only want to update a part of the window which in most case we don't really want to do, so here we will use update for default.



















