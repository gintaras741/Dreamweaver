var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

app.MapOpenApi("/api/openapi/{documentName}.json");
app.MapControllers();

await app.RunAsync();

// for WebApplicationFactory in tests
public partial class Program;
