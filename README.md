# Tombola
The project consists in the design and implementation of a distributed
game where two entities CLIENT and SERVER share information about the current state of a game and interact with each other for making user play such game.
- Server sets up the game, organizes the interaction flow, communicates the results to the participants.
- Clients are the players, whose goal is to play the moves of the game as and when instructed by the server.

Required Gaming Flow
1. Discovery Phase: during the discovery phase, the server advertises the beginning of a new match for the game, sharing also the rules and all the information required for joining the game. This means that clients can reach the server in order to get the information required and to register/subscribe to the current match. Server can close the registration phase depending on different criteria, for instance after a predefined timeout exceeded or because a maximum number of clients joined the match.
2. Playing Phase: in the playing phase the server communicates the current state of the game, indicating which player should make the move. If the game does not involve turns it just broadcasts a status. After that, it collects the answer of the players, updating the game state and notifying back the players. This loop is repeated as many times as needed by the game to be completed or until a winner is identified by the server.
3. Conclusion Phase: the conclusion phase starts as soon as the server identifies a possible winner of the game or the game finishes because a timeout exceeded. The server then communicates the results of the game to all the competitors. The results contain also a dashboard containing the previous results and it is updated with the last scores.

If we translate this game following the “Peer Gaming” dynamics, we can set up the interactions as follows: first the servers advertises the beginning of a new match, then clients subscribe to the match and, at some point, the server closes the subscriptions. 
Before starting the game the server distributes the “bingo cards” (one or more) to all clients. 
Then the server starts the game, which consists in multiple repetitions of the same phase. In each phase the server extracts randomly a number (from 1 to 90) and communicates it to all clients. 
Clients need to check their bingo cards and mark all the boxes containing the number (this can also be done automatically) and then they should notify back the server about any points that they have made (for instance, one of “terno”, “cinquina”, “tombola” or “nothing”). 
If one player has marked all the boxes in one of his/her cards, then the server declares that the game is over and that player is the winner. 
This is an example of a game that requires a basic interaction, where all players play at the same time and the server only repeats the same phase over and over until a certain condition is met.
