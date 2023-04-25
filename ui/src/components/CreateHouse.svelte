<section class="bg-[color:var(--color-primary)]">
    <div class="py-8 px-4 mx-auto max-w-lg">
        <h2 class="mb-4 text-xl font-bold text-white mt-24">Create a new property</h2>
        <form action="#">
            <div class="grid gap-4 ">
                <div class="w-full">
                    <label for="price" class="block mb-2 text-sm font-medium text-white">Price</label>
                    <input type="number" name="price" id="price" class="bg-[color:var(--color-secondary)] border border-[color:var(--color-tertiary)] text-white text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5" placeholder="$200,000">
                </div>
                <div>
                    <label for="category" class="block mb-2 text-sm font-medium text-white">Shell Type</label>
                    <select id="category" class="bg-[color:var(--color-secondary)] border border-[color:var(--color-tertiary)] text-white text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full p-2.5">
                        <option value=1>Shell 1</option>
                        <option value=2>Shell 2</option>
                        <option value=3>Shell 3</option>
                        <option value=4>Shell 4</option>
                        <option value=5>Shell 5</option>
                        <option value=6>Shell 6</option>
                        <option value=7>Shell 7</option>
                        <option value=8>Shell 8</option>
                        <option value=9>Shell 9</option>
                        <option value=10>Shell 10</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="inline-flex items-center px-12 py-2.5 mt-4 text-sm font-medium text-center text-white bg-[color:var(--color-secondary)] rounded-lg border border-[color:var(--color-tertiary)]">
                Set Entrance
            </button>
        </form>
    </div>
  </section>