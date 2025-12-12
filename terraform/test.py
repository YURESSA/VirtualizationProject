
import asyncio
import aiohttp
import time

URL = "http://158.160.207.118/events"
TOTAL = 2000000         # всего запросов
CONCURRENCY = 2000    # параллельных задач

sem = asyncio.Semaphore(CONCURRENCY)

async def fetch(session, n):
    async with sem:
        start = time.time()
        try:
            async with session.get(URL, timeout=30) as resp:
                status = resp.status
                await resp.read()   # или .text() если нужно тело
        except Exception as e:
            status = f"ERR:{e.__class__.__name__}"
        elapsed = time.time() - start
        print(f"#{n} {status} {elapsed:.3f}s")

async def main():
    async with aiohttp.ClientSession() as session:
        tasks = [asyncio.create_task(fetch(session, i)) for i in range(1, TOTAL+1)]
        await asyncio.gather(*tasks)

if __name__ == "__main__":
    asyncio.run(main())
