import { ConnectButton } from "@mysten/dapp-kit";
import { Box, Card, Flex, Heading, Button } from "@radix-ui/themes";
import "./index.css"

function App() {
  return (
    <>
      <Flex
        position="sticky"
        px="4"
        py="2"
        justify="between"
        style={{
          borderBottom: "1px solid var(--gray-a2)",
        }}
      >
        <Box>
          <Heading>Haiku Voting System</Heading>
        </Box>

        <Box>
          <div className="my-connect-button">
            <ConnectButton />
          </div>
        </Box>
      </Flex>
      
      <Flex
        justify="center"
        align="center"
        gap="8"
        style={{ minHeight: "80vh" }}
      >
        <OrganizerCard />
        <VoterCard />
      </Flex>

    </>
  );
}

function OrganizerCard() {
  return (
    <Box width="280px" height="600px">
      <Card style={{ height: "100%", background: "#181e2a" }}>
        <Flex
          direction="column"
          align="center"
          justify="between"
          style={{ height: "100%", padding: "32px 0" }}
        >
          <Heading as="h2" size="5" weight="bold" style={{ color: "#fff" }}>
            Organizer
          </Heading>

          <img src="../icon/icon1.png" alt="Organizer Icon" style={{ width: 120, height: 120, objectFit: 'contain', margin: '24px 0' }} />

          <Button
            size="3"
            style={{
              background: "linear-gradient(90deg, #1e40af, #2563eb)",
              color: "#fff",
              borderRadius: "2em",
              width: 140,
              fontSize: "1.2rem",
            }}
          >
            Enter
          </Button>
        </Flex>
      </Card>
    </Box>
  );
}

function VoterCard() {
  return (
    <Box width="280px" height="600px">
      <Card style={{ height: "100%", background: "#181e2a" }}>
        <Flex
          direction="column"
          align="center"
          justify="between"
          style={{ height: "100%", padding: "32px 0" }}
        >
          <Heading as="h2" size="5" weight="bold" style={{ color: "#fff" }}>
            Voter
          </Heading>

          <img src="../icon/icon2.png" alt="Voter Icon" style={{ width: 120, height: 120, objectFit: 'contain', margin: '24px 0' }} />

          <Button
            size="3"
            style={{
              background: "linear-gradient(90deg, #1e40af, #2563eb)",
              color: "#fff",
              borderRadius: "2em",
              width: 140,
              fontSize: "1.2rem",
            }}
          >
            Enter
          </Button>
        </Flex>
      </Card>
    </Box>
  );
}

export default App;
