using System.Net;
using Microsoft.AspNetCore.Mvc.Testing;

namespace Dreamweaver.Api.Tests;

public sealed class SmokeTests(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    [Fact]
    public async Task OpenApiDocument_IsServed()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/openapi/v1.json", UriKind.Relative), TestContext.Current.CancellationToken);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
