class Todo
{
  String total;
  Todo({
    this.total,
});
  Todo.fromMap(Map map):
      this.total = map['total'];
  Map toMap()
  {
    return
        {
          'total': this.total,
        };
  }
}