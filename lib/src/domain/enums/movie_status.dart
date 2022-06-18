enum MovieStatus {
  rumored,
  inProduction,
  postProduction,
  released,
  canceled,
  planned,
}

MovieStatus movieStatusFromString(String status) {
  switch (status) {
    case 'Rumored': return MovieStatus.rumored;
    case 'Planned': return MovieStatus.planned;
    case 'In Production': return MovieStatus.inProduction;
    case 'Post Production': return MovieStatus.postProduction;
    case 'Released': return MovieStatus.released;
    default: return MovieStatus.canceled;
  }
}