<script>
    export let loadingText = 'Searching available listings...', progressWidth="40%";
</script>

<div class="loading-page">
    <div>
        <p class="align-middle">{loadingText}</p>
    
        <div class="w-96 bg-gray-200 h-2 dark:bg-gray-700">
            <div class="bg-blue-600 h-2" style="width: {progressWidth}"></div>
        </div>
    </div>
</div>

<style>
    .loading-page {
        margin: auto;
    }

    .loading-page > div {
        display: flex;
        flex-direction: column;
        justify-content: center;
        text-align: center;
    }

    .loading-page > div > p {
        padding-bottom: 1rem;
    }
</style>