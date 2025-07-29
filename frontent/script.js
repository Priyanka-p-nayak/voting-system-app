const candidates = ['Participants A', 'Participants B', 'Participants C'];

function loadVotes() {
  const storedVotes = JSON.parse(localStorage.getItem('votes')) || {};
  const resultsDiv = document.getElementById('results');
  resultsDiv.innerHTML = '';

  candidates.forEach(candidate => {
    const count = storedVotes[candidate] || 0;
    resultsDiv.innerHTML += `<p><strong>${candidate}:</strong> ${count} votes</p>`;
  });
}

function castVote(candidate) {
  if (sessionStorage.getItem('hasVoted')) {
    document.getElementById('message').textContent = '⚠️ You have already voted!';
    return;
  }

  let votes = JSON.parse(localStorage.getItem('votes')) || {};
  votes[candidate] = (votes[candidate] || 0) + 1;
  localStorage.setItem('votes', JSON.stringify(votes));
  sessionStorage.setItem('hasVoted', 'true');

  document.getElementById('message').textContent = `✅ Thank you! You voted for ${candidate}`;
  loadVotes();
}

window.onload = loadVotes;
let votes = { A: 0, B: 0, C: 0 };

function vote(participant) {
  votes[participant]++;
  document.getElementById(`votes-${participant}`).innerText = `Votes: ${votes[participant]}`;
}
